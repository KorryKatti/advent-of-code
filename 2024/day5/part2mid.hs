import System.IO (readFile, writeFile)

-- Helper function to find the middle element of a list
findMiddle :: [Int] -> Int
findMiddle xs = xs !! (length xs `div` 2)

-- Parse a line into a list of integers
parseLine :: String -> [Int]
parseLine = map read . words . map (\c -> if c == ',' then ' ' else c)

-- Main function to read output2.txt and write middle elements to middle2.txt
main :: IO ()
main = do
  -- Read lines from output2.txt
  contents <- readFile "output2.txt"
  let sequences = map parseLine (lines contents)

  -- Extract middle elements
  let middleElements = map findMiddle sequences

  -- Write middle elements to middle2.txt
  writeFile "middle2.txt" (unlines $ map show middleElements)

  putStrLn "Middle elements written to middle2.txt"
