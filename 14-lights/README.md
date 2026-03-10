
# Introduction

There are multiple types of lights. We already discovered the AmbientLight and the PointLight. We will now explore all the different classes in detail and how to use them.

# Setup

Because we are going to use lights, we must use a material that reacts to lights. We could have used MeshLambertMaterial, MeshPhongMaterial or MeshToonMaterial, but instead we will use the MeshStandardMaterial because it's the most realistic one.

# AmbientLight

The AmbientLight applies omnbidirectional lighting on all geometries of the scene. The first parameter is the color and the second parameter is the intensity. As for the materials, you can set the properties directly while instantiating the AmbientLight class:

    // Ambient light
    const ambientLight = new THREE.AmbientLight(0xffffff, 1)
    scene.add(ambientLight)

Or the properties can be changed after instantiation:

    // Ambient light
    const ambientLight = new THREE.AmbientLight()
    ambientLight.color = new THREE.Color(0xffffff)
    ambientLight.intensity = 1
    scene.add(ambientLight)

If all we have is an AmbientLight, we'll have the same effect as for a MeshBasicMaterial because all faces of the geometries will be lit equally.

In real life, when an object is lit, the sides of the objects at the opposite of the light won't be totally black because light bounces on the walls and other objects. Light bouncing is not supported in Three.js, but we can add a dim AmbientLight to fake this light bounce.

# DirectionalLight

The DirectionalLight will have a sun-like effect as if the sun rays were traveling in parallel. The first parameter is color and the second parameter is the intensity:

    // Directional light
    const directionalLight = new THREE.DirectionalLight(0x00fffc, 0.9)
    scene.add(directionalLight)

By default, the light will seem to come from above. To change that, we must move the whole light by using the position property like it were a common Three.js object.

    directionalLight.position.set(1, 0.25, 0)

The distance of the light doesn't matter for now. The rays come from an infinite space and travel in parallel to the infinite opposite.

# HemisphereLight

The HemisphereLight is similar to the AmbientLight but with a different color from the sky than the color coming from the ground. Faces facing the sky will be lit by one color while another color will light faces facing the ground.

The first parameter is the color corresponding to the sky color, the second parameter is the groundColor and the third parameter is the intensity:

    // Hemisphere light
    const hemisphereLight = new THREE.HemisphereLight(0xff0000, 0x0000ff, 0.9)
    scene.add(hemisphereLight)

# PointLight

The PointLight is almost like a lighter. The light source is infinitely small, and the light spreads uniformly in every direction. The first parameter is the color and the second parameter is the intensity:

    // Point light
    const pointLight = new THREE.PointLight(0xff9000, 1.5)
    scene.add(pointLight)

We can move it like any object:

    pointLight.position.set(1, - 0.5, 1)

For a realistic result, we usually only play with the intensity parameter of the light, but we actually have more control thanks to the distance and decay parameters.

The distance value is 0 by default, meaning that the distance is actually infinite. If we change the distance value to around 0.5, we can see the intensity drop down drastically

The lower the decay value, the faster the light will decay. For a realistic and physically based result, we'd rather keep the default value of 2.

    const pointLight = new THREE.PointLight(0xff9000, 1.5, 0, 2)

# RectAreaLight

The RectAreaLight works like the big rectangle lights on a photoshoot set. It's a mix of the directional light and a diffuse light. The first parameter is the color, the second parameter is the intensity, the third parameter is width of the rectangle, and the fourth parameter is its height:

    // Rect area light
    const rectAreaLight = new THREE.RectAreaLight(0x4e00ff, 6, 1, 1)
    scene.add(rectAreaLight)

The RectAreaLight only works with MeshStandardMaterial and MeshPhysicalMaterial. We can then move the light and rotate it. To ease the rotation, we can use the lookAt(...) method that we saw in a previous lesson:

    rectAreaLight.position.set(- 1.5, 0, 1.5)
    rectAreaLight.lookAt(new THREE.Vector3())

A Vector3 without any parameter will have its x, y, and z to 0.

# SpotLight

The SpotLight works like a flashlight. It's a cone of light starting at a point and oriented in a direction. Here is a list of its parameters:
- color: the color
- intensity: the strength
- distance: the distance at which the intensity drops to 0
- angle: how large is the beam
- penumbra: how diffused is the contour of the beam
- decay: how fast the light dims

    // Spot light
    const spotLight = new THREE.SpotLight(0x78ff00, 4.5, 10, Math.PI * 0.1, 0.25, 1)
    spotLight.position.set(0, 2, 3)
    scene.add(spotLight)

Roting the SpotLight is a little harder. The instance has a property named target, which is an Object3D. The SpotLight is always looking at that target object. But if we try to change its position, the SpotLight won't budge.

The position, along with the rotation and scale, are compiled into what we call a transform matrix. This transform matrix is what really matters at the end. We will need to add this spotLight.target in the scene.

    scene.add(spotLight.target)

And now the light has turned on the left.

# Performance

Lights are great and can be realistic if well used. The problem is that lights can cost a lot when it comes to performance. The GPU will have to do many calculations like the distance from the face to the light, how much that face is facing the light, if the face is in the spot light cone, etc.

Try to add as few lights as possible and try to use the lights that cost less.

Minimal cost:
- AmbientLight
- HemisphereLight
Moderate cost:
- DirectionalLight
- PointLight
High cost:
- SpotLight
- RectAreaLight

# Baking

A good technique for lighting is called baking. We can do this in a 3D software. The downside is that, once the lighting is baked, we can't move the lights because there are none.

# Helpers

Positioning and orienting the lights is hard. To assist us, we can use helpers. Only the following helpers are supported:
- HemisphereLightHelper
- DirectionalLightHelper
- PointLightHelper
- RectAreaLightHelper
- SpotLightHelper

To use them, simply instantiate those classes. Use the corresponding light as a parameter, and add them to the scene. The second parameter enables you to change the helper's size:

    const hemisphereLightHelper = new THREE.HemisphereLightHelper(hemisphereLight, 0.2)
    scene.add(hemisphereLightHelper)

    const directionalLightHelper = new THREE.DirectionalLightHelper(directionalLight, 0.2)
    scene.add(directionalLightHelper)

    const pointLightHelper = new THREE.PointLightHelper(pointLight, 0.2)
    scene.add(pointLightHelper)

    const spotLightHelper = new THREE.SpotLightHelper(spotLight, 0.2)
    scene.add(spotLightHelper)

The RectAreaLightHelper is a little harder to use. Right now, the class isn't part of the THREE core variables. We must import it from the examples dependencies as we did with OrbitControls:

    import { RectAreaLightHelper } from 'three/examples/jsm/helpers/RectAreaLightHelper.js'

Then you can use it:

    const rectAreaLightHelper = new RectAreaLightHelper(rectAreaLight)
    scene.add(rectAreaLightHelper)