module Main where

import Prelude

import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI component unit body

component :: forall query input output m. H.Component query input output m
component =
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
render _ = HH.div_ []
