# Camera2D+
The "Camera2D+" plugin enhances the functionality of the built-in Camera2D node in Godot, providing additional features for game camera management. With Camera2D+, you can easily implement screen shake effects, screen flashes, and cinematic mode transitions in your 2D games. Take control of your in-game camera and create immersive and dynamic gameplay experiences with this versatile and user-friendly plugin.

## Camera2D+ Functionalities
Camera2D+ is an enhanced Camera2D node with additional features to elevate your game or project. This plugin provides the following advanced functionalities:

1. ***Screen Shake***:
    - Camera2D+ can simulate screen shaking effects, adding intensity and realism to your game.
    - You can customize the duration, intensity, and type of shaking.
    - It smoothly returns the camera to its original position after the shake, ensuring a seamless transition.

2. ***Screen Flash***:
    - Create stunning visual effects by flashing the screen with Camera2D+.
    - Customize the flash color, duration, and intensity to suit your game's needs.
    - This feature is useful for emphasizing critical moments or creating dramatic effects in your game.

3. ***Follow Node***:
    - Camera2D+ allows you to follow a specific node, even if it's not a direct child of the camera.
    - Easily track your player character or any other object, keeping it in the center of the view.
    - Achieve dynamic camera movement for a more immersive gaming experience.
    - 
4. ***Smooth Camera Zoom In & Out***:
    - Perform a camera zoom in/out easily on your target
    - Choose between a smooth camera zoom transition or an imidiate chop transition to your desired target zoom
    - Customize the smoothness parameter of your zooming mechanism
    - Include initial zoom in or out on level load (camera ready) by adjusting default TARGET_ZOOM_LEVEL
  
5. ***Cinematic Mode***:
    - Simulate the cinematic screen effect with Camera2D+ by adding black bars to the corners of the screen.
    - Include optional zooming in and out for better cinematic effect, grabbing player attention towards your target
    - This feature can give your game or project a cinematic feel, mimicking the widescreen format often seen in movies.
    - Customize the size and position of the black bars to achieve the desired cinematic effect.

These powerful functionalities enhance your camera management capabilities, allowing you to create engaging and visually appealing games and projects. Camera2D+ is a valuable addition to your Godot toolkit, offering flexibility and creative control over your camera scenes.

## Camera2D+ Basic Functions
Camera2D+ provides a set of fundamental functions to help you create immersive visual effects in your game or project. Here are the core functions that allow you to generate the screen flash, screen shake, and cinematic effects:

1. ***flash(color: Color = Color.WHITE, duration: float = 0.5, hold: float = 0.0) -> void***:
    - The `flash` function triggers a screen flash effect with the specified `color`. By default, it uses white.
    - You can customize the `duration` of the flash effect, which determines how long the screen will remain flashed.
    - The `hold` parameter allows you to hold the flash effect for an additional duration before it begins to fade out.
    - This function is useful for highlighting important events or creating visual impact.

2. ***add_shake(strength: float) -> void***:
    - The `add_shake` function adds a shaking effect to the camera with the given strength.
    - You can call this function multiple times to intensify the shaking effect. For example, calling it with values 10 and 5 successively will result in a total shaking effect of 15.
    - Use this function to simulate various degrees of camera tremors.

3. ***set_shake(strength: float) -> void***:
    - The `set_shake` function sets the camera's shaking effect to a specific strength.
    - Calling this function more than once will overwrite the previous strength value. For instance, if you call it with values 10 and 5 successively, the total shaking effect will be 5, as the second call overrides the first.
    - Useful to prevent camera shake stacking.

4. ***set_follow_node(new_node_path: NodePath) -> void***:
    - With the `set_follow_node` function, you can designate a new node for the camera to follow.
    - For this feature to work effectively, ensure that the node to be followed is not a child of the camera, and the camera is not its child either.
    - Provide the node's path rather than the node itself to specify the target.

5. ***toggle_cinematic(horizontal: bool, vertical: bool = false, transotion_duration: float = 0.3, include_zoom: float = 0.0) -> void:***:
    - The `toggle_cinematic` function activates or deactivates the cinematic effect along the horizontal and vertical axes.
    - If you set `horizontal` to true, it enables the cinematic effect on the horizontal axis.
    - To enable both horizontal and vertical cinematic effects, set `vertical` to true as well.
    - You can change the default `transotion_duration` from `0.3` second to have a more or less delayed cinematic effect to kick in
    - You can include any float vakue for `include_zoom` to include a camera zoom effect during cinematic effect
    - Camera zoom in or out effect is determined based on the passed value. If the value is higher than current zoom level, then you will have a camera zoom in effect. Otherwise it will be a zoom out effect.
    - You can leave the value at defaulted `0.0` to not include any zooming effect.
    - This function is great for creating cinematic moments in your game, adding a touch of professional cinematography.
  
6. ***tilt_position(tilt_x: float, tilt_y: float) -> void***:
    - The tilt_position function instantly moves the camera by `tilt_x` on the X-axis and `tilt_y` on the Y-axis. It then smoothly returns to its original position, creating a bounce-like effect.
    - This function is excellent for adding dynamic responses to your game's events. For example, you can use it to intensify the impact of a music beat or enhance the feedback for in-game actions.

7. ***tilt_angle(tilt: float) -> void***:
    - The `tilt_angle` function provides a similar effect to `tilt_position`, but instead of altering the camera's position, it changes the camera's angle.
    - This function can be used to simulate dynamic camera adjustments in response to various game events. For instance, you can create a cinematic feel by adjusting the camera's angle during specific gameplay moments.
  
8. ***set_zoom_level(new_zoom_level: float) -> void:***
   - You can pass a float value as `new_zoom_level` such as 1.0 that would be placed as the target zoom for the camera to transition to.
   - The main camera transition for zooming in and out takes place during `perform_camera_zoom` that camera automatically performs during each `process` cycle.
   - By performing `set_zoom_level` you essentially indicate to camera to transition to new zoom target automatically and you dont need to do anything else.
    
These core functions provide you with the building blocks to implement captivating visual effects and camera behavior in your Godot projects using the Camera2D+ plugin. Feel free to experiment and combine these functions to achieve your desired results!

## Exploring Additional Properties
The Camera2D+ plugin offers various additional properties that you can manipulate through the Godot Inspector. These properties allow you to fine-tune and customize your camera's behavior to suit your game's specific needs. Feel free to experiment and have fun adjusting these settings to achieve the desired visual effects and camera behavior.

### How to Use:
1. ***Open the Godot Inspector***: In the Godot editor, select the Camera2D+ node in your scene. You will find a list of properties in the Inspector panel.

2. ***Modify Properties***: Hover over the property names to view tooltips that provide brief descriptions of each property's purpose. Adjust the values of these properties to change how the Camera2D+ behaves in your game.

3. ***Experiment Creatively***: Play around with different property values to achieve the desired camera effects. Whether it's tweaking the zoom level, adjusting smoothing parameters, or enabling cinematic mode, these properties offer you a wide range of creative possibilities.

If you ever have questions or need more information about a specific property, don't hesitate to hover your mouse over the property name in the Inspector. A tooltip with a description will appear, helping you understand the function and purpose of that property.

The Camera2D+ plugin empowers you to create dynamic and engaging camera experiences in your Godot projects. Enjoy exploring and customizing these properties to bring your game's visuals to life!
