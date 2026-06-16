# FX Converter: A Functional Approach to Exchange Rate Computation

A high-integrity currency conversion engine implemented in Haskell, leveraging real-time market data through a pure functional pipeline.

## 1. Mathematical Specification

The system models currency conversion as a linear transformation over the field of real numbers, constrained by time-variant exchange rate coefficients.

### 1.1. Core Transformation
Given a source amount $a \in \mathbb{R}^{+}$, a source currency $C_{src}$, and a target currency $C_{target}$, the converted amount $a'$ is computed as:

$$a' = a \times \mathcal{R}(C_{src}, C_{target}, t)$$

where $\mathcal{R}$ is the exchange rate function at time $t$.

### 1.2. Rate Discovery
The exchange rate is derived from a base-relative mapping provided by the Frankfurter API. For a base currency $B$:

$$\mathcal{R}(B, C_i, t) = \text{API-Response}(B, t)[C_i]$$

## 2. Technical Architecture

### 2.1. Domain Modeling (`Types.hs`)
The system utilizes Haskell's algebraic data types (ADTs) to ensure domain integrity and prevent invalid state representation.

```haskell
data Currency = USD | EUR | KRW | JPY | GBP | CNY
  deriving (Show, Eq, Ord)

type Amount = Double

data ConversionResult = ConversionResult
  { fromAmount  :: Amount
  , toAmount    :: Amount
  , appliedRate :: Double
  }
```

### 2.2. Functional Pipeline
The application logic is partitioned into three distinct phases:

1.  **I/O Layer (`Rates.hs`)**: Performs monadic network effects to retrieve JSON-encoded market data and decodes it into a structured `Map`.
2.  **Logic Layer (`Converter.hs`)**: A pure computation engine that performs lookups and arithmetic transformations.
3.  **Presentation Layer (`Main.hs`)**: Orchestrates the data flow and handles terminal output formatting.

## 3. Implementation Details

-   **Data Consistency**: Uses `Data.Map.Strict` for $O(\log n)$ lookup performance and predictable memory usage.
-   **JSON Serialization**: Employs `Data.Aeson` for type-safe parsing of API responses.
-   **Network**: Utilizes `Network.HTTP.Simple` for robust HTTPS communication.

## 4. Usage

### Prerequisites
-   [Haskell Stack](https://docs.haskellstack.org/en/stable/README/)

### Build & Execution
```bash
stack build
stack exec fx-converter-exe
```

## 5. Development Roadmap
- [ ] Implement unit tests for core conversion logic in `test/Spec.hs`.
- [ ] Add support for historical rate lookups.
- [ ] Implement cross-rate triangulation for non-base currency pairs without additional API calls.
