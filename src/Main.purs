module Main where

import Prelude

import Effect (Effect)
import Halogen as H
import Halogen.Aff as HAff
import Halogen.HTML as HTML
import Halogen.HTML.Events as Events
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HAff.runHalogenAff do
  body <- HAff.awaitBody
  runUI rootComponent unit body

rootComponent :: forall query input output m. H.Component query input output m
rootComponent =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction }
    }

type State = Unit
type Action = Unit

initialState :: forall input. input -> State
initialState _ = unit

handleAction :: forall output m. Action -> H.HalogenM State Action () output m Unit
handleAction = pure

render :: forall m. State -> H.ComponentHTML Action () m
render _ = HTML.div_
  [ HTML.canvas []
  ]
