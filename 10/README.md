
# Introduction

What are textures and what can we do with them?

## What Are Textures?

Textures are images that will cover the surface of a geometry. Many types of textures can have different effects on the appearance of a geometry, not just the color.

## Color (Albedo)

The albedo texture is the most simple one. It'll only take the pixels of the texture and apply them to the geometry.

## Alpha

The alpha texture is a grayscale image where white will be visible and black won't.

## Height

The height texture is a grayscale image that will move the vertices to create some relief. You'll need to add subidivision if you want to see it.

## Normal

The normal texture will add small details. It won't move the vertices, but it will lure the light into thinking that the face is oriented differently. Normal textures are useful to add details with good performance because you don't need to subdivide the geometry.

## Ambient Occlusion

The ambient occlusion texture is a grayscale image that will fake shadow in the surface's crevices. While it's not physically accurate, it helps to create contrast.

## Metalness

The metalness texture is a grayscale image that will specify which part is metallic (white) and non-metallic (black). This information helps to create reflection.

## Roughness

The roughness is a grayscale image that comes with metalness, and that will specify which part is rough (white) and which part is smooth (black). This information will help to dissipate the light. A carpet is very rugged, and you won't see the light reflection on it, while the water's surface is very smooth, and you can see the light reflecting on it. Here, the wood is uniform because there is a clear coat on it.

## PBR

Those textures (especially metalness and roughness) follow what we call PBR principles. PBR stands for Physically Based Rendering. It regroups many techniques that tend to follow real-life directions to get realistic results.

While there are many other techniques, PBR is becoming the standard for realistic renders, and many software, engines, and libraries are using it.

# How to Load Textures

## Getting the URL of the Image

To load the texture, we need the URL of the image file. Because we are using a build tool, there are two ways of getting it. You can put the image texture in the /src/ folder and import it like a JavaScript dependency.

        import imageSource from './image.png'

Or you can put the image in the /static/ folder and access it by adding the path of the image.

        const imageSource = './image.png'

## Loading the Image

### Using Native JavaScript

You must create an Image instance, listen to the load event, and then change its src property to start loading the image:

        const image = new Image()
        image.onload = () =>
        {
            console.log('image loaded')
        }
        image.src = '/textures/door/color.jpg'

We cannot use the image directly. We need to create a Texture from the image first.

This is because WebGL needs a very specific format that can be accessed by the GPU and also because some changes will be applied to the textures like the mipmapping.

        const image = new Image()
        image.addEventListener('load', () =>
        {
            const texture = new THREE.Texture(image)
        })
        image.src = '/textures/door/color.jpg'

Now wee need to use the texture in the material. But the texture variable has been declared in a function that we cannot access outside of that function. We can get around this by creating the texture outside of the function and updating it once the image is loaded.

        const image = new Image()
        const texture = new THREE.Texture(image)
        image.addEventListener('load', () => {
            texture.needsUpdate = true
        })
        image.src = '/textures/door/color.jpg'

Now we can immediately use the texture variable. The image will be transparent until it is loaded. To see the texture on the cube, replace the color property by map and use the texture as value.

        const material = new THREE.MeshBasicMaterial({ map: texture })

You should see the door texture on each side of your cube, but the texture looks oddly grayish. It's because the image has been encoded using the sRGB color space. We can fix it like this.

        const texture = new THREE.Texture(image)
        texture.colorSpace = THREE.SRGBColorSpace

The general idea is that textures that are used on the map or matcap properties of a material are supposed to be encoded in sRGB and we need to set the colorSpace to THREE.sRGBColorSpace but only for those.

### Using TextureLoader

There is a more straightforward way to load an image. Instantiate a variable using the TextureLoader class and use its .load(...) method.

        const textureLoader = new THREE.TextureLoader()
        const texture = textureLoader.load('/textures/door/color.jpg')
        texture.colorSpace = THREE.SRGBColorSpace

Internally, Three.js will do what it did before to load the image and update the texture once it's ready. You can load as many textures as you want with only one TextureLoader instance. You can send 3 functions after the path. They will be called for the following events:
- load when the image loaded successfully
- progress when the loading is progressing
- error if something went wrong

        const textureLoader = new THREE.TextureLoader()
        const texture = textureLoader.load(
            '/textures/door/color.jpg',
            () =>
            {
                console.log('loading finished')
            },
            () =>
            {
                console.log('loading progressing')
            },
            () =>
            {
                console.log('loading error')
            }
        )
        texture.colorSpace = THREE.SRGBColorSpace

### Using LoadingManager

If there are multiple images to load and want to mutualize the events like being notified when all the images are loaded, you can use a LoadingManager.

        const loadingManager = new THREE.LoadingManager()
        const textureLoader = new THREE.TextureLoader(loadingManager)

You can listen to the various events by replacing the following properties by your own functions onStart, onLoad, onProgress, and onError.

        const loadingManager = new THREE.LoadingManager()
        loadingManager.onStart = () =>
        {
            console.log('loading started')
        }
        loadingManager.onLoad = () =>
        {
            console.log('loading finished')
        }
        loadingManager.onProgress = () =>
        {
            console.log('loading progressing')
        }
        loadingManager.onError = () =>
        {
            console.log('loading error')
        }

        const textureLoader = new THREE.TextureLoader(loadingManager)

We can now start loading all the images we need.

        // ...

        const colorTexture = textureLoader.load('/textures/door/color.jpg')
        colorTexture.colorSpace = THREE.SRGBColorSpace
        const alphaTexture = textureLoader.load('/textures/door/alpha.jpg')
        const heightTexture = textureLoader.load('/textures/door/height.jpg')
        const normalTexture = textureLoader.load('/textures/door/normal.jpg')
        const ambientOcclusionTexture = textureLoader.load('/textures/door/ambientOcclusion.jpg')
        const metalnessTexture = textureLoader.load('/textures/door/metalness.jpg')
        const roughnessTexture = textureLoader.load('/textures/door/roughness.jpg')

Since we renamed texture to colorTexture, we need to change it in the material too.

        const material = new THREE.MeshBasicMaterial({ map: colorTexture })

## UV Unwrapping

It can be trickier to place a texture on geometries that are not cubes. The texture will be stretched or squeezed in different ways to cover it. This is called UV unwrapping, and each vertex will have a 2D coordinate on a flat plane.

Those UV coordinates are generated by Three.js when you use the primitives. If you create your own geometry and want to apply a texture to it, you have to specify the UV coordinates.

If you are making the geometry using a 3D software, you will have to do the UV unwrapping. Most 3D software also has auto unwrapping that should do the trick.

## Transforming the Texture

### Repeat

You can repeat the texture using the repeat property, which is a Vector2, meaning that it has x and y properties.

If you try and change these properties, the texture will not repeat but get smaller, and the last pixel will be stretched.

        const colorTexture = textureLoader.load('/textures/door/color.jpg')
        colorTexture.colorSpace = THREE.SRGBColorSpace
        colorTexture.repeat.x = 2
        colorTexture.repeat.y = 3

This is due to the texture not being set up to repeat itself by default. To change that, you have to update the wrapS and wrapT properties using the THREE.RepeatWrapping constant.
- wrapS is for the x axis
- wrapT is for the y axis

        colorTexture.wrapS = THREE.RepeatWrapping
        colorTexture.wrapT = THREE.RepeatWrapping

You can also alternate the direction with THREE.MirroredRepeatWrapping.

        colorTexture.wrapS = THREE.MirroredRepeatWrapping
        colorTexture.wrapT = THREE.MirroredRepeatWrapping

### Offset

You can offset the texture using the offset property that is also a Vector2 with x and y properties. Changing these will simply offset the UV coordinates.

        colorTexture.offset.x = 0.5
        colorTexture.offset.y = 0.5

### Rotation

You can rotate the texture using the rotation property, which is a simple number corresponding to the angle in radians.

        colorTexture.rotation = Math.PI * 0.25

If you remove the offset and repeat properties, you'll see that the rotation occurs around the bottom left of the cube's faces.

That is the 0, 0 UV coordinates. If you want to change the pivot of that rotation, you can do it using the center property which is also a Vector2.

        colorTexture.rotation = Math.PI * 0.5
        colorTexture.center.x = 0.5
        colorTexture.center.y = 0.5

The texture will now rotate on its center.

## Filtering and Mipmapping

If you look at the cube's top face while this face is almost hidden, you'll see a blurry texture. This is due to the filtering and the mipmapping.

Mipmapping is a technique that consists of creating half a smaller version of a texture again and again until you get a 1x1 texture. All those texture variations are sent to the GPU, and the GPU will choose the most appropriate version of the texture.

Three.js and the GPU already handle all of this, and you can just set what filter algorithm to use. There are two types of filter algorithms, the minification filter and the magnification filter.

### Minification Filter

The minification filter happens when the pixels of texture are smaller than the pixels of the render, i.e. the texture is too big for the surface it covers.

You can change the minification filter of the texture using the minFilter property.

There are 6 possible values.
- THREE.NearestFilter
- THREE.LinearFilter
- THREE.NearestMipmapNearestFilter
- THREE.NearestMipmapLinearFilter
- THREE.LinearMipmapNearestFilter
- THREE.LinearMipmapLinearFilter

The default is THREE.LinearMipmapLinearFilter.

If you are using a device with a pixel ratio above one, you won't see much of a difference.

### Magnification Filter

The magnification filter works just like the minification filter, but when the pixels of the texture are bigger than the render's pixels. In other words, the texture is too small for the surface it covers.

The texture gets blurry because it's a very small texture on a very large surface. If the effect isn't too exaggerated, the user will probably not notice it.

You can change the magnification filter of the texture using the magFilter property. There are only two possible values.
- THREE.NearestFilter
- THREE.LinearFilter

The default is THREE.LinearFilter. If you test the THREE.NearestFilter, you'll see the base image is preserved, and you get a pixelated texture.

        colorTexture.magFilter = THREE.NearestFilter

It can be useful if you're going for a Minecraft style with pixelated textures.  

THREE.NearestFilter is cheaper than the others, and you should get better performances when using it.

Only use the mipmaps for the minFilter property. If you are using the THREE.NearestFilter, you don't need the mipmaps, and you can deactivate them with colorTexture.generateMipmaps = false.

        colorTexture.generateMipmaps = false
        colorTexture.minFilter = THREE.NearestFilter

That will slightly offload the GPU.

## Texture Format and Optimisation

When you are preparing your textures, you must keep 3 crucial elements in mind.
- the weight
- the size/resolution
- the data

### The Weight

Don't forget that the user going to your website will have to download those textures. You can use most of the types of images we use on the web like .jpg (lossy compression but usually lighter) or .png (lossless compression but usually heavier).

Apply the usual methods and compression websites to get an acceptable image that is as light as possible.

### The Size

Each pixel of the textures you are using will have to be stored on the GPU regardless of the image's weight. And like your hard drive, the GPU has storage limitations. It's even worse because the automatically generated mipmapping increases the number of pixels that have to be stored.

Try to reduce the size of your images as much as possible.

Three.js will produce a half smaller version of the texture repeatedly until gets a 1x1 texture. Because of that, your texture width and height must be a power of 2, i.e. 512x512, 1024x1024, or 512x2048.

If you are using a texture with a width or height different than a power of 2 value, Three.js will try to stretch it to the closest power of 2 number, which can have visually poor results.

### The Data

Textures support transparency. Since jpg files don't have an alpha channel, you may prefer using a png or an alpha map.

If you are using a normal texture, you will probably want to have the exact values for each pixel's red, green, and blue channels, or you might end up with visual glitches. For that, you'll need to use a png because its lossless compression will preserve the values.

# Where to Find Textures

It's hard to find the perfect textures. There are many websites, but the textures aren't always right or always free.

Here are some good websites.
- poliigon.com
- 3dtextures.me
- arroway-textures.ch

You can also create your own using photos and 2D software like Photoshop or even procedural textures with software like Substance Designer.