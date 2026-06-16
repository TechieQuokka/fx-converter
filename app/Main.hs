module Main (main) where

import Types
import Rates
import Converter

-- 결과 출력
printResult :: ConversionResult -> IO ()
printResult r =
  putStrLn $ show (fromAmount r) ++ " " ++ show (fromCurr r)
          ++ " = "
          ++ show (roundTo 2 (toAmount r)) ++ " " ++ show (toCurr r)

-- 소수점 반올림
roundTo :: Int -> Double -> Double
roundTo n x =
  let factor = 10 ^ n
  in fromIntegral (round (x * factor) :: Int) / factor

main :: IO ()
main = do
  putStrLn "=== FX Converter v0.1 (실시간) ==="
  putStrLn ""

  -- 실시간 환율 가져오기
  putStrLn "환율 데이터 가져오는 중..."
  table <- fetchRates USD

  putStrLn ""
  putStrLn "[ 1000 USD 변환 ]"
  let results = convertAll table 1000 USD
  mapM_ printResult results

  putStrLn ""
  putStrLn "[ 1000000 KRW 변환 ]"
  tableKRW <- fetchRates KRW
  let results2 = convertAll tableKRW 1000000 KRW
  mapM_ printResult results2
