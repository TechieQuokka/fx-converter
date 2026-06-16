module Rates
  ( getRate
  , fetchRates
  ) where

import Types
import qualified Data.Map.Strict as Map
import Data.Aeson
import Data.Aeson.Key (fromString)
import Network.HTTP.Simple

-- API 응답 파싱용 타입
newtype RatesResponse = RatesResponse
  { rates :: Map.Map String Double
  } deriving (Show)

instance FromJSON RatesResponse where
  parseJSON = withObject "RatesResponse" $ \v ->
    RatesResponse <$> v .: fromString "rates"

-- Currency -> String
currencyToStr :: Currency -> String
currencyToStr USD = "USD"
currencyToStr EUR = "EUR"
currencyToStr KRW = "KRW"
currencyToStr JPY = "JPY"
currencyToStr GBP = "GBP"
currencyToStr CNY = "CNY"

-- String -> Maybe Currency
strToCurrency :: String -> Maybe Currency
strToCurrency "USD" = Just USD
strToCurrency "EUR" = Just EUR
strToCurrency "KRW" = Just KRW
strToCurrency "JPY" = Just JPY
strToCurrency "GBP" = Just GBP
strToCurrency "CNY" = Just CNY
strToCurrency _     = Nothing

-- frankfurter.app에서 실시간 환율 가져오기
fetchRates :: Currency -> IO (Map.Map (Currency, Currency) Double)
fetchRates base = do
  let url = "https://api.frankfurter.app/latest?from=" ++ currencyToStr base
  request  <- parseRequest url
  response <- httpLBS request
  let body = getResponseBody response
  case eitherDecode body :: Either String RatesResponse of
    Left err -> do
      putStrLn $ "API 오류: " ++ err
      return Map.empty
    Right ratesResp ->
      return $ Map.fromList
        [ ((base, to), r)
        | (k, r) <- Map.toList (rates ratesResp)
        , Just to <- [strToCurrency k]
        ]

-- 환율 조회
getRate :: Map.Map (Currency, Currency) Double -> Currency -> Currency -> Maybe Double
getRate table from to = Map.lookup (from, to) table
