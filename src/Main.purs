module Main where

import Prelude

import Effect (Effect)
import Halogen as H
import Halogen.Aff as HAff
import Halogen.HTML as HTML
import Halogen.HTML.Events as Event
import Halogen.HTML.CSS (style)
import Halogen.HTML.Properties as Prop
import Halogen.VDom.Driver (runUI)
import CSS as CSS
import CSS.Font as Font
import Data.NonEmpty ((:|))

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
  [ HTML.canvas [Prop.width 500, Prop.height 500]
  , HTML.h2_ [HTML.text "wip :3"]
  , attribution
  ]

cutesyFooterStyle :: CSS.CSS
cutesyFooterStyle = do
  CSS.fontFamily ["DejaVu Sans Mono"] (Font.monospace :| [])

attribution :: forall w i. HTML.HTML w i
attribution = HTML.div_
  [ HTML.p [style cutesyFooterStyle] 
    [ HTML.text "made with "
    , HTML.b_ [HTML.text "halogen"]
    , HTML.text " and sheer force of will. (c) UnrelatedString 2025. "
    ]
  , HTML.a [Prop.href "https://github.com/UnrelatedString/bingous"]
    [ HTML.text "github.com/UnrelatedString/bingous"
    ]
  ]
