import System.IO.Unsafe (unsafePerformIO)
import Data.List.Split (splitOn)

{-# NOINLINE input #-}
input :: String
input = unsafePerformIO $ readFile "./input.txt"

ranges :: [[Int]]
ranges = parseInputRanges input

-- Parse into list of lists
parseInputRanges :: String -> [[Int]]
parseInputRanges s =
  let clean = filter (/= '\n') s
      rangeStrs = splitOn "," clean
      parseRange r =
        let [start, end] = map read $ splitOn "-" r
        in [start..end]
  in map parseRange rangeStrs

invalid1 :: Int -> Bool
invalid1 n =
  let s = show n
      len = length s
  in even len &&
     let half = len `div` 2
     in take half s == drop half s

invalid2 :: Int -> Bool
invalid2 n =
  let s = show n
      len = length s
      -- Try all possible pattern lengths that divide evenly
      divisors = [d | d <- [1..len `div` 2], len `mod` d == 0]
  in any (\d ->
        let pattern = take d s
        in concat (replicate (len `div` d) pattern) == s
     ) divisors

answer1 :: Int
answer1 = sum $ map (sum . filter invalid1) ranges

answer2 :: Int
answer2 = sum $ map (sum . filter invalid2) ranges
