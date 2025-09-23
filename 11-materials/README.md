
# Introduction

Materials are used to put a color on each visible pixel of the geometries.

The algorithms that decide on the color of each pixel are written in programs called shaders. Writing shaders is one of the most challenging parts of WebGL and Three.js, but Three.js has many built-in materials with pre-made shaders.

# Prepare the Scene

To test the materials, we should prepare a scene and load some textures.

        /**
        * Objects
        */
        // MeshBasicMaterial
        const material = new THREE.MeshBasicMaterial()

        const sphere = new THREE.Mesh(
            new THREE.SphereGeometry(0.5, 16, 16),
            material
        )
        sphere.position.x = -1.5

        const plane = new THREE.Mesh(
            new THREE.PlaneGeometry(1, 1),
            material
        )

        const torus = new THREE.Mesh(
            new THREE.TorusGeometry(0.3, 0.2, 16, 32),
            material
        )
        torus.position.x = 1.5

        scene.add(sphere, plane, torus)

We can now rotate our objects on the tick function.

        /**
        * Animate
        */
        const clock = new THREE.Clock()

        const tick = () =>
        {
            const elapsedTime = clock.getElapsedTime()

            // Update objects
            sphere.rotation.y = 0.1 * elapsedTime
            plane.rotation.y = 0.1 * elapsedTime
            torus.rotation.y = 0.1 * elapsedTime

            sphere.rotation.x = - 0.15 * elapsedTime
            plane.rotation.x = - 0.15 * elapsedTime
            torus.rotation.x = - 0.15 * elapsedTime

            // ...
        }

        tick()

The materials we are going to discover are using textures in many different ways.

        /**
        * Textures
        */
        const textureLoader = new THREE.TextureLoader()

        const doorColorTexture = textureLoader.load('./textures/door/color.jpg')
        const doorAlphaTexture = textureLoader.load('./textures/door/alpha.jpg')
        const doorAmbientOcclusionTexture = textureLoader.load('./textures/door/ambientOcclusion.jpg')
        const doorHeightTexture = textureLoader.load('./textures/door/height.jpg')
        const doorNormalTexture = textureLoader.load('./textures/door/normal.jpg')
        const doorMetalnessTexture = textureLoader.load('./textures/door/metalness.jpg')
        const doorRoughnessTexture = textureLoader.load('./textures/door/roughness.jpg')
        const matcapTexture = textureLoader.load('./textures/matcaps/1.png')
        const gradientTexture = textureLoader.load('./textures/gradients/3.jpg')

Textures used as map and matcap are supposed to be encoded in sRGB and we need to inform Three.js of this by setting their colorSpace to THREE.SRGBColorSpace.

        doorColorTexture.colorSpace = THREE.SRGBColorSpace
        matcapTexture.colorSpace = THREE.SRGBColorSpace

To ensure that all the textures are well-loaded, you can use them on your material with the map property, as we saw in the Textures lesson.

        const material = new THREE.MeshBasicMaterial({ map: doorColorTexture })

Until now, we only used the MeshBasicMaterial, which applies a uniform color or texture to our geometry.

# MeshBasicMaterial

MeshBasicMaterial is probably the most "basic" material. You can send most of its properties while instancing the material in the object we send as a parameter, but you can also change those properties in the instance directly.

        const material = new THREE.MeshBasicMaterial({
            map: doorColorTexture
        })

        // Equivalent
        const material = new THREE.MeshBasicMaterial({})
        material.map = doorColorTexture

# Map

The map property will apply a texture on the surface of the geometry.

        material.map = doorColorTexture

# Color

The color property will apply a uniform color on the surface of the geometry. When you are changing the color property directly, you must instantiate a Color class.

        material.color = new THREE.Color('#ff0000')
        material.color = new THREE.Color('#f00')
        material.color = new THREE.Color('red')
        material.color = new THREE.Color('rgb(255, 0, 0)')
        material.color = new THREE.Color(0xff0000)

Combining color and map will tint the texture with the color.

        material.map = doorColorTexture
        material.color = new THREE.Color('#ff0000')

# Wireframe

The wireframe property will show the triangles that compose your geometry with a thin line of 1px regardless of the distance of the camera.

        // material.map = doorColorTexture
        // material.color = new THREE.Color('#ff0000')
        material.wireframe = true

# Opacity

The opacity property controls the transparency but, to work, you need to set the transparent property to true in order to inform Three.js that this material now supports transparency.

        material.transparent = true
        material.opacity = 0.5

# AlphaMap

Now that the transparency is working, we can use the alphaMap property to control the transparency with a texture.

        material.transparent = true
        material.alphaMap = doorAlphaTexture

# Side

The side property lets you decide with side of the faces is visible. By default, the front side is visible (THREE.FrontSide), but you can show the backside instead (THREE.BackSide) or both (THREE.DoubleSide).

        material.side = THREE.DoubleSide

Try to avoid using DoubleSide whenever possible because it actually requires more resources when rendering, even though the side isn't visible.

# MeshNormalMaterial

The MeshNormalMaterial displays a nice purple, blueish color that looks like the normal texture we saw in the Textures lessons.

        const material = new THREE.MeshNormalMaterial()

Normals are information encoded in each vertex that contains the direction of the outside of the face. If you displayed those normals as arrows, you would get straight lines coming out of each vertex that compose your geometry.

You can use Normals for many things like calculating how to illuminate the face or how the environment should reflect or refract on the goemetries' surface.

When using the MeshNormalMaterial, the color will just display the normal orientation relative to the camera. If you rotate around the sphere, you'll see that the color is always the same, regardless of which part of the sphere you're looking at.

While you can use some of the properties we discovered with the MeshBasicMaterial like wireframe, transparent, opacity, and side, there is also a new property called flatShading.

        material.flatShading = true

flatShading will flatten the faces, meaning that the normals won't be interpolated between the vertices, meaning that the normals won't be interpolated between the vertices.

MeshNormalMaterial can be useful to debug the normals, but it also looks great, and you can use it just the way it is.

# MeshMatcapMaterial

MeshMatcapMaterial can look great while remaining very performant. To work, it needs a reference texture that looks like a sphere.

The material will then pick colors from the texture according to the normal orientation relative to the camera..

        const material = new THREE.MeshMatcapMaterial()
        material.matcap = matcapTexture

The meshes will appear illuminated, but it's an illusion created by the texture. There is no light in the scene. The only problem is that the result is the same regardless of the camera orientation. Also, you cannot update the lights because there are none.

        const matcapTexture = textureLoader.load('/textures/matcaps/2.png')

You can create your own matcaps using 3D software by rendering a sphere in front of the camera in a square image. You can also use 2D software or online tools.

# MeshDepthMaterial

The MeshDepthMaterial will simply color the geometry in white if it's close to the camera's near value and in black if it's close to the far value.

        const material = new THREE.MeshDepthMaterial()

This material is used to save the depth in a texture, which can be used for later complex computations like handling shadows.

# MeshLambertMaterial

        const material = new THREE.MeshLambertMaterial()

If you try this, the screen will be entirely black. This is because the MeshLambertMaterial is the first material in the list that requires lights to be seen.

        /**
        * Lights
        */
        const ambientLight = new THREE.AmbientLight(0xffffff, 1)
        scene.add(ambientLight)

        const pointLight = new THREE.PointLight(0xffffff, 30)
        pointLight.position.x = 2
        pointLight.position.y = 3
        pointLight.position.z = 4
        scene.add(pointLight)

MeshLambertMaterial supports the same properties as the MeshBasicMaterial but also some properties related to lights. The MeshLambertMaterial is the most performant material that uses lights, but the parameters aren't convenient. You can see strange patterns in the geometry if you look closely at rounded geometries like the sphere.

# MeshPhongMaterial

The MeshPhongMaterial is similar to the MeshLambertMaterial, but the strange patterns are less visible, and you can see the light reflection on the surface of the geometry.

        const material = new THREE.MeshPhongMaterial()

MeshPhongMaterial is less performant than MeshLambertMaterial, but it doesn't matter much at this level.

You can control the light reflection with the shininess property. The higher the value, the shinier the surface. You can also change the color of the reflection by using the specular property.

        material.shininess = 100
        material.specular = new THREE.Color(0x1188ff)

# MeshToonMaterial

MeshToonMaterial is similar to MeshLambertMaterial in terms of properties but with a cartoonish style.

        const material = new THREE.MeshToonMaterial()

By default, you only get a two-part coloration (one for the shadow and one for the light). To add more steps to the coloration, you can use the gradientTexture we loaded at the start of the lesson on the gradientMap property.

        material.gradientMap = gradientTexture

The cartoon effect doesn't work anymore because the gradient texture is a very small texture of 3 by 1 pixels. When extracting the pixels, the GPU will blend them.

Fortunately, we can control how the GPU handles such texture thanks to the minFilter and magFilter, similar to mipmapping.

        const material = new THREE.MeshToonMaterial()
        gradientTexture.minFilter = THREE.NearestFilter
        gradientTexture.magFilter = THREE.NearestFilter
        material.gradientMap = gradientTexture

You should now see the cartoon effect with an intermediate step because the THREE.NearestFilter isn't actually using any mipmap versions of the texture, we can deactivate the generation of the mipmaps in order to free some memory by setting gradientTexture.generateMipmaps to false.

        gradientTexture.minFilter = THREE.NearestFilter
        gradientTexture.magFilter = THREE.NearestFilter
        gradientTexture.generateMipmaps = false

# MeshStandardMaterial

The MeshStandardMaterial uses physically basied rendering principles. Like the MeshLambertMaterial and the MeshPhongMaterial, it supports lights but with a more realistic algorithm and better parameters like roughness and metalness.

It's called "standard" because the PBR has become the standard in many software, engines, and libraries. The idea is to have a realistic result with realistic parameters, and you should have a very similar result.

        const material = new THREE.MeshStandardMaterial()

You can change the roughness and the metalness properties directly.

        material.metalness = 0.45
        material.roughness = 0.45

We can add a GUI to tweak the metalness and roughness values to find what looks the best.

## Adding an Environment Map

The environment map is like an image of what's surrounding the scene. You can use it to add reflection, refraction, and lighting to your objects in addition to the current DirectionalLight and AmbientLight.

To load the environment map file, we need to use the RGBELoader. Unlike the textureLoader, we need to send a callback function as the second parameter. To apply it to our scene, we need to change its mapping property to THREE.EquirectangularReflectionMapping and then assign it to the background and environment properties of the scene.

        import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader.js'

        /**
        * Environment Map
        */
        const rgbeLoader = new RGBELoader()
        rgbeLoader.load('./textures/environmentMap/2k.hdr', (environmentMap) => 
        {
            environmentMap.mapping = THREE.EquirectangularReflectionMapping

            scene.background = environmentMap
            scene.environment = environmentMap
        })

You should see the environment reflect on the surface of the geometry. The environment map is also compatible with MeshLambertMaterial and MeshPhongMaterial.

## More Properties

The map property allows you to apply a simple texture.

        material.map = doorColorTexture

The aoMap property will add shoadows where the texture is dark. Add the aoMap using the doorAmbientOcclusionTexture and control the intensity using the aoMapIntensity property.

        material.aoMap = doorAmbientOcclusionTexture
        material.aoMapIntensity = 1

The crevices should look darker, which creates contrast and adds dimension. Note that the aoMap only affects light created by AmbientLight, the environment map, and the HemisphereLight.

The displacementMap property will move the vertices to create true relief.

        material.displacementMap = doorHeightTexture

It won't look good due to the lack of vertices on our geometries and the displacement being too strong.

        new THREE.SphereGeometry(0.5, 64, 64)
        new THREE.PlaneGeometry(1, 1, 100, 100)
        new THREE.TorusGeometry(0.3, 0.2, 64, 128)

        material.displacementScale = 0.1

Instead of specifying uniform metalness and roughness for the whole geometry, we can use metalnessMap and roughnessMap

        material.metalnessMap = doorMetalnessTexture
        material.roughnessMap = doorRoughnessTexture

The reflection looks weird because the metalness and roughness properties still affect the metalnessMap and roughnessMap. In order to work properly, we need to set both the metalness and roughness to 1.

        material.metalness = 1
        material.roughness = 1

Now we see reflections on the metal parts of the door. The texture is made to look like there is a varnish coating on the wood, which is why we can still perceive some reflections.

The normalMap will fake the normal orientation and add details to the surface regardless of the subdivision.

        material.normalMap = doorNormalTexture

You can change the normal intensity with the normalScale property.

        material.normalScale.set(0.5, 0.5)

And finally, you can control the alpha using the alphaMap property. Don't forget to set the transparent property to true.

        material.transparent = true
        material.alphaMap = doorAlphaTexture

# MeshPhysicalMaterial

The MeshPhysicalMaterial is the same as the MeshStandardMaterial but with the support of additional effects like clearcoat, sheen, iridescence, and transmission.

To implement this, duplicate the whole MeshStandardMaterial, its properties, and its tweaks, then replace the class with MeshPhysicalMaterial.

        /**
        * MeshPhysicalMaterial
        */
        // Base material

        const material = new THREE.MeshPhysicalMaterial()
        material.metalness = 1
        material.roughness = 1
        material.map = doorColorTexture
        material.aoMap = doorAmbientOcclusionTexture
        material.aoMapIntensity = 1
        material.displacementMap = doorHeightTexture
        material.displacementScale = 0.1
        material.metalnessMap = doorMetalnessTexture
        material.roughnessMap = doorRoughnessTexture
        material.normalMap = doorNormalTexture
        material.normalScale.set(0.5, 0.5)

        gui.add(material, 'metalness').min(0).max(1).step(0.0001)
        gui.add(material, 'roughness').min(0).max(1).step(0.0001)

All previous properties are supported because MeshPhysicalMaterial inherits from MeshStandardMaterial.

## Clearcoat

The clearcoat will simulate a thin layer of varnish on top of the actual material. This layer has its own reflective properties.

        // Clearcoat
        material.clearcoat = 1
        material.clearcoatRoughness = 0

        gui.add(material, 'clearcoat').min(0).max(1).step(0.0001)
        gui.add(material, 'clearcoatRoughness').min(0).max(1).step(0.0001)

## Sheen

The sheen will highlight the material when seen from a narrow angle. We can see this effect on fluffy material like fabric.

        // Sheen
        material.sheen = 1
        material.sheenRoughness = 0.25
        material.sheenColor.set(1, 1, 1)

        gui.add(material, 'sheen').min(0).max(1).step(0.0001)
        gui.add(material, 'sheenRoughness').min(0).max(1).step(0.0001)
        gui.addColor(material, 'sheenColor')

## Iridescence

The iridescence is an effect where we can see color artifacts like a fuel puddle, soap bubbles, or LaserDiscs.

Add the iridescence, iridescenceIOR, and iridescenceThicknessRange properties.

        // Iridescence
        material.iridescence = 1
        material.iridescenceIOR = 1
        material.iridescenceThicknessRange = [ 100, 100 ]

        gui.add(material, 'iridescence').min(0).max(1).step(0.0001)
        gui.add(material, 'iridescenceIOR').min(1).max(2.333).step(0.0001)
        gui.add(material.iridescenceThicknessRange, '0').min(1).max(1000).step(1)
        gui.add(material.iridescenceThicknessRange, '1').min(1).max(1000).step(1)

## Transmission

The transmission will enable light to go through the material. It's more than just transparency with opacity because the image behind the object gets deformed.

Add the transmission, ior, and thickness properties.

        material.transmission = 1
        material.ior = 1.5
        material.thickness = 0.5

        gui.add(material, 'transmission').min(0).max(1).step(0.0001)
        gui.add(material, 'ior').min(1).max(10).step(0.0001)
        gui.add(material, 'thickness').min(0).max(1).step(0.0001)

The objects feel translucent.

ior stands for Index of Refraction and depends on the type of material you want to simulate. A diamond has an ior of 2.417, water has an ior of 1.333, and air has an ior of 1.000293.

The thickness is a fixed value. The actual thickness of the object isn't taken into account. Currently, we have a lot of maps messing up our material, but the transmission looks good with a pure material too.

MeshPhysicalMaterial is the worst material in terms of performance. You will not get a good frame rate on every device if you apply this material to many objects covering most of the screen.