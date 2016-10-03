# glsl-ggx

glsl ggx lighting model

# example

[view this example](https://substack.neocities.org/ggx_dragon.html)

``` js
var regl = require('regl')()
var camera = require('regl-camera')(regl, {
  distance: 100,
  center: [0,58,0],
  theta: Math.PI/2
})
var glx = require('glslify')
var anormals = require('angle-normals')
var dragon = require('stanford-dragon')

var draw = regl({
  frag: glx`
    precision mediump float;
    #pragma glslify: ggx = require('glsl-ggx')
    uniform vec3 eye, lightpos;
    varying vec3 vpos, vnorm;
    void main () {
      vec3 N = vnorm, V = normalize(eye-vpos), L = normalize(lightpos-vpos);
      float spec = max(0.0,ggx(N,V,L,0.2,0.7));
      vec3 c = vec3(0.955,0.637,0.538); // copper
      gl_FragColor = vec4(pow(c*spec,vec3(2.2)),1);
    }
  `,
  vert: `
    precision mediump float;
    uniform mat4 projection, view;
    attribute vec3 position, normal;
    varying vec3 vpos, vnorm;
    void main () {
      vpos = position;
      vnorm = normal;
      gl_Position = projection * view * vec4(position,1);
    }
  `,
  attributes: {
    position: dragon.positions,
    normal: anormals(dragon.cells, dragon.positions)
  },
  elements: dragon.cells,
  uniforms: {
    lightpos: function (context) {
      var t = context.time*4, r = 30
      return [Math.cos(t)*r,Math.sin(t)*r+60,200]
    }
  }
})
regl.frame(function () {
  regl.clear({ color: [0.4,0.2,0.4,1], depth: true })
  camera(function () { draw() })
})
```

# api

``` glsl
#pragma glslify: ggx = require('glsl-ggx')
```

## float l = ggx(vec3 N, vec3 V, vec3 L, float roughness, float F0)

Compute the ggx specular lighting from:

* `vec3 N` - surface normal
* `vec3 V` - normalized view direction
* `vec3 L` - normalized light direction
* `float roughness` - smooth (0.0) to rough (1.0)
* `float F0` - fresnel term, 0.0 to 1.0

# license

BSD
