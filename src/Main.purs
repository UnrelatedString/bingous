module Main where

import Prelude

import Effect (Effect)
import Effect.Class (class MonadEffect)
import Halogen as H
import Halogen.Aff as HAff
import Halogen.HTML as HTML
import Halogen.HTML.Events as Event
import Halogen.HTML.CSS (style)
import Halogen.HTML.Properties as Prop
import Halogen.VDom.Driver (runUI)
import Halogen.Canvas.Declarative (declarativeCanvas)
import CSS as CSS
import CSS.Font as Font
import Data.NonEmpty ((:|))
import Data.Int (toNumber)
import Type.Proxy (Proxy(..))
import Web.CSSOM.MouseEvent (offsetX, offsetY)
import DOM.HTML.Indexed.InputType (InputType(InputUrl))

import Web.HTML (window)
import Web.HTML.Window (document)
import Web.DOM.Document ()

import Graphics.Canvas (Context2D, arc, strokePath)
import Data.Number (tau)

main :: Effect Unit
main = HAff.runHalogenAff do
  body <- HAff.awaitBody
  runUI rootComponent unit body

rootComponent :: forall query input output m. MonadEffect m => H.Component query input output m
rootComponent =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction }
    }

type Point = { x :: Number, y :: Number }

type State =
  { clicked :: Point
  , inputUrl :: String
  }

data Action = Click Point
            | UrlInput String
            | Ignore

type RootSlots :: forall k. k -> Row Type
type RootSlots m = ( canvas :: forall query. H.Slot query Void ComponentIndices )

_canvas :: Proxy "canvas"
_canvas = Proxy

data ComponentIndices = TheCanvas
derive instance Eq ComponentIndices
derive instance Ord ComponentIndices

initialState :: forall input. input -> State
initialState _ = 
  { clicked: { x: 0.0, y: 0.0 }
  , inputUrl: ""
  }

handleAction :: forall output m. MonadEffect m => Action -> H.HalogenM State Action (RootSlots m) output m Unit
handleAction (Click {x, y}) = H.modify_ _{clicked = {x, y}}
handleAction (UrlInput url) = H.modify_ _{inputUrl = url}
handleAction Ignore = pure unit

-- I could use an actual Halogen ref for this but then I have to get it from HalogenM for my Canvas's Effect
bgPreviewImgId :: String
bgPreviewImgId = "bgPreviewImgId"

render :: forall m. MonadEffect m => State -> H.ComponentHTML Action (RootSlots m) m
render state = HTML.div
  [ Event.onClick \e -> Click { x: toNumber $ offsetX e, y: toNumber $ offsetY e }
  ]
  [ HTML.slot_ _canvas TheCanvas declarativeCanvas { width: 500, height: 500, draw: draw state }
  , HTML.form_
    [ HTML.p_ [HTML.text "Enter image URL for background or existing card:"]
    , HTML.input [Prop.type_ InputUrl, Event.onValueInput UrlInput]
    ]
  , HTML.p_ [HTML.text $ "You entered: " <> state.inputUrl]
  , HTML.img [Prop.src state.inputUrl, Prop.id bgPreviewImgId]
  , HTML.h2_ [HTML.text "wip :3"]
  , attribution
  ]

draw :: State -> Context2D -> Effect Unit
draw state ctx = do
  -- shit I just realized uh. how do I make sure the image actually loaded and rendered?? maybe I should blob
  -- whatever I'll at least try this

  let { x, y } = state.clicked
  strokePath ctx do
    arc ctx
      { x, y
      , radius: 20.0
      , start: 0.0
      , end: tau
      , useCounterClockwise: false
      }

cutesyFooterStyle :: CSS.CSS
cutesyFooterStyle = do
  CSS.fontFamily ["DejaVu Sans Mono"] (Font.monospace :| [])
  CSS.fontSize $ CSS.px 9.5

attribution :: forall w i. HTML.HTML w i
attribution = HTML.footer [style cutesyFooterStyle]
  [ HTML.p_ 
    [ HTML.text "made with "
    , HTML.b_ [HTML.text "purescript halogen"]
    , HTML.text " and sheer force of will. (c) UnrelatedString 2025."
    ]
  , HTML.a [Prop.href "https://github.com/UnrelatedString/bingous"]
    [ HTML.text "github.com/UnrelatedString/bingous"
    ]
  ]
