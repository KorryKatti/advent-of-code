import System.IO (readFile, writeFile)

-- Helper function to find the middle element of a list
findMiddle :: [Int] -> Int
findMiddle xs = xs !! (length xs `div` 2)

-- Parse a line into a list of integers
parseLine :: String -> [Int]
parseLine = map read . words

-- Main function to read output.txt and write middle elements to middle.txt
main :: IO ()
main = do
  -- Read lines from output.txt
  contents <- readFile "output.txt"
  let sequences = map parseLine (lines contents)

  -- Extract middle elements
  let middleElements = map findMiddle sequences

  -- Write middle elements to middle.txt
  writeFile "middle.txt" (unlines $ map show middleElements)

  putStrLn "Middle elements written to middle.txt"
