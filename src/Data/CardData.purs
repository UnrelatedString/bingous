module Data.CardData
  ( CardData (..)
  , FiveThings (..)
  )
where

newtype CardData = CardData {}

-- can do dependent type shenanigans when I add support for non-5x5 grids :p
newtype FiveThings a = FiveThings
  { first :: a
  , second :: a
  , third :: a
  , fourth :: a
  , fifth :: a
  }