-- Strict makes a huge difference.
{-# LANGUAGE Strict #-}

-- A tiny improvement.
{-# LANGUAGE UnboxedTuples #-}

-- Note: did not try to bother to use unboxed Int.

module Main where

-- Using a strict Maybe makes a huge difference.
import Prelude hiding (Maybe(..))
import Data.Maybe.Strict (Maybe(..), isJust)

import Control.Monad.Primitive (PrimMonad, PrimState)
import System.Random.MWC (withSystemRandom, asGenIO, Gen, uniform)

type NodeCell = Maybe Node

data Node = Node
  { xValue :: {-# UNPACK #-} Int
  , yValue :: {-# UNPACK #-} Int
  , left :: NodeCell
  , right :: NodeCell
  }

newNode :: PrimMonad m => Gen (PrimState m) -> Int -> m Node
newNode gen x =
  do
    y <- uniform gen
    pure $ Node
      { xValue = x
      , yValue = y
      , left = Nothing
      , right = Nothing
  }

merge :: NodeCell -> NodeCell -> NodeCell
merge Nothing greater = greater
merge lower Nothing = lower
merge lower@(Just lowerNode) greater@(Just greaterNode)
  | yValue lowerNode < yValue greaterNode =
    Just $ lowerNode { right = merge (right lowerNode) greater }
  | otherwise =
    Just $ greaterNode { left = merge lower (left greaterNode) }

splitBinary :: NodeCell -> Int -> (# NodeCell, NodeCell #)
splitBinary Nothing _ = (# Nothing, Nothing #)
splitBinary (Just origNode) value
  | xValue origNode < value =
    case splitBinary (right origNode) value of
      (# l, r #) -> (# Just (origNode { right = l }), r #)
  | otherwise =
    case splitBinary (left origNode) value of
      (# l, r #) -> (# l, Just (origNode { left = r }) #)

merge3 :: NodeCell -> NodeCell -> NodeCell -> NodeCell
merge3 lower equal greater = (lower `merge` equal) `merge` greater

type SplitResult = (# NodeCell, NodeCell, NodeCell #)

split :: NodeCell -> Int -> SplitResult
split orig value =
  case splitBinary orig value of
    (# lower, equalGreater #) ->
      case splitBinary equalGreater (value+1) of
        (# equal, greater #) -> (# lower, equal, greater #)

newtype Tree = Tree { root :: NodeCell }

emptyTree :: Tree
emptyTree = Tree { root = Nothing }

hasValue :: Tree -> Int -> (# Tree, Bool #)
hasValue tree x =
  case split (root tree) x of
    (# lower, equal, greater #) ->
      (# Tree { root = merge3 lower equal greater }, isJust equal #)

insert :: PrimMonad m => Gen (PrimState m) -> Tree -> Int -> m Tree
insert gen tree x =
  case split (root tree) x of
    (# lower, equal, greater #) ->
      if isJust equal
      then pure $ Tree { root = merge3 lower equal greater }
      else do
        newEqualNode <- newNode gen x
        pure $ Tree { root = merge3 lower (Just newEqualNode) greater }

erase :: Tree -> Int -> Tree
erase tree x =
  case split (root tree) x of
    (# lower, _, greater #) -> Tree { root = merge lower greater }

run :: PrimMonad m => Gen (PrimState m) -> m Int
run gen = loop 1 emptyTree 5 0 where
  loop i tree cur res
    | i > (1000000 :: Int) = pure res
    | otherwise =
      let a = i `mod` 3
          newCur = (cur * 57 + 43) `mod` 10007
          newI = i+1
      in case a of
           0 -> do
             newTree <- insert gen tree newCur
             loop newI newTree newCur res
           1 ->
             let newTree = erase tree newCur
             in loop newI newTree newCur res
           2 ->
             case hasValue tree newCur of
               (# newTree, has #) ->
                 let newRes = if has then res+1 else res
                 in loop newI newTree newCur newRes
           _ ->
             loop newI tree newCur res

main :: IO ()
main = do
  result <- (withSystemRandom . asGenIO) run
  print result
