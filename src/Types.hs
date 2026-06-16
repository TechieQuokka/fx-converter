module Types
  ( Currency(..)
  , Amount
  , ExchangeRate(..)
  , ConversionResult(..)
  ) where

-- 지원 통화
data Currency
  = USD  -- 미국 달러
  | EUR  -- 유로
  | KRW  -- 한국 원
  | JPY  -- 일본 엔
  | GBP  -- 영국 파운드
  | CNY  -- 중국 위안
  deriving (Show, Eq, Ord)

-- 금액
type Amount = Double

-- 환율 (from -> to -> rate)
data ExchangeRate = ExchangeRate
  { fromCurrency :: Currency
  , toCurrency   :: Currency
  , rate         :: Double
  } deriving (Show, Eq)

-- 변환 결과
data ConversionResult = ConversionResult
  { fromAmount   :: Amount
  , fromCurr     :: Currency
  , toAmount     :: Amount
  , toCurr       :: Currency
  , appliedRate  :: Double
  } deriving (Show, Eq)
