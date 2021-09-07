var util = require('util')

function FrameConfig(real, virtual) {
  this.realWidth = real.width
  this.realHeight = real.height
  this.virtualWidth = 200//virtual.width
  this.virtualHeight = 400//virtual.height
  this.rotation = virtual.rotation
}

FrameConfig.prototype.toString = function() {
  return util.format(
    '%dx%d@%dx%d/%d'
  , this.realWidth
  , this.realHeight
  , this.virtualWidth
  , this.virtualHeight
  , this.rotation
  )
}

module.exports = FrameConfig
