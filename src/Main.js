export const drawTheImageIGuess = (ctx) => (imgId) => () => {
    var theFuckingThing = window.document.getElementById(imgId);
    ctx.drawImage(theFuckingThing, 0, 0)
}
