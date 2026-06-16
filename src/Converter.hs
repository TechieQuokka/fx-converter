module Converter
  ( convert
  , convertAll
  ) where

import Types
import Rates
import qualified Data.Map.Strict as Map

-- 단일 변환
convert :: Map.Map (Currency, Currency) Double -> Amount -> Currency -> Currency -> Maybe ConversionResult
convert table amount from to =
  case getRate table from to of
    Nothing -> Nothing
    Just r  -> Just ConversionResult
      { fromAmount  = amount
      , fromCurr    = from
      , toAmount    = amount * r
      , toCurr      = to
      , appliedRate = r
      }

-- 한 통화에서 모든 통화로 변환
convertAll :: Map.Map (Currency, Currency) Double -> Amount -> Currency -> [ConversionResult]
convertAll table amount from =
  [ result
  | to <- [USD, EUR, KRW, JPY, GBP, CNY]
  , to /= from
  , Just result <- [convert table amount from to]
  ]
