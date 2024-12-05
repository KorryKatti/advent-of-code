import Data.List (elemIndex)
import Data.Maybe (fromJust, isNothing)
import System.IO (writeFile)

type Rule = (Int, Int)
type Sequence = [Int]

-- Parse a rule from "x|y" to (x, y)
parseRule :: String -> Rule
parseRule str = (read x, read y)
  where
    (x, _:y) = break (== '|') str

-- Parse a sequence from "a,b,c" to [a, b, c]
parseSequence :: String -> Sequence
parseSequence = map read . words . map (\c -> if c == ',' then ' ' else c)

-- Check if a sequence is valid based on rules
isValid :: [Rule] -> Sequence -> Bool
isValid rules seq = all ruleIsValid rules
  where
    ruleIsValid (a, b) =
      case (elemIndex a seq, elemIndex b seq) of
        (Just idxA, Just idxB) -> idxA < idxB -- Both are found, check their order
        _                      -> True       -- If either is missing, rule is ignored

-- Main function to read files and validate sequences
main :: IO ()
main = do
  -- Read rules from rules.txt
  ruleContents <- readFile "rules.txt"
  let rules = map parseRule (lines ruleContents)

  -- Read sequences from pages.txt
  pageContents <- readFile "pages.txt"
  let sequences = map parseSequence (lines pageContents)

  -- Validate each sequence
  let results = zip sequences (map (isValid rules) sequences)

  -- Print results to console
  mapM_ printResult results

  -- Write valid sequences to output.txt
  let validSequences = [seq | (seq, True) <- results]
  writeFile "output.txt" (unlines $ map formatSequence validSequences)

-- Helper to print results
printResult :: (Sequence, Bool) -> IO ()
printResult (seq, valid) = do
  putStrLn $ unwords (map show seq) ++ ": " ++ if valid then "Valid" else "Invalid"

-- Helper to format a sequence for output
formatSequence :: Sequence -> String
formatSequence = unwords . map show
