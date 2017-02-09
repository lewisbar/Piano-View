# Piano-View
A reusable piano view with six octaves, one octave at a time, the octave is selected through a segmented control. This is just the view part, including the handling of touch events. You need some kind of audio engine to actually hear sound. If you use the project as it is, the names of the notes you are playing or releasing will just be printed to the console.  
You can use this project as a starting point and replace or modify the placeholder parts (bacically the AudioEngine class and maybe the ViewController class). Or, to use it in your Xcode project:  
  
##A. Setting up the view:  
1. Put the PianoController, PianoView and KeysView classes (i.e. everything in the group "Piano") into your project.  
2. Drag a view into your storyboard and pin it with AutoLayout as you wish. This will be your piano view.  
3. In the identity inspector, make it a PianoView.  
4. Once the storyboard has reloaded, a piano should appear.  
5. In the attributes inspector, change the background color to change the color of the white keys.  
6. Change the tint color to change the color of the black keys.  
7. The segmented control will use the same colors as the keys.  
  
##B. Setting up the controller part:  
1. Open the assistent editor.  
2. Ctrl-drag from your PianoView to your ViewController class to create an IBOutlet.  
3. You need a class that adapts the PianoDelegate protocol with the following methods:  
         - func play(note: String)  
         - func release(note: String)   
  This delegate will receive the played note as a String, for example C4, D#3 etc.  
  See the AudioEngine class in my project for a placeholder example.  
  Again, to actually hear sound, you need to take that String and generate the corresponding note yourself.  
4. In your ViewController class in viewDidLoad, create a PianoController(withPianoView: PianoView, delegate: PianoDelegate), handing it the PianoView which you created the outlet for, and an instance of the class you created that adapts the PianoDelegate protocol. See the ViewController class in my project for a working example.  
  
##C. Behind the scenes:  
The KeysView tells the PianoController when a key is pressed or released, slided upon or slided away from. And, of course, which key it was. This should also work for several keys pressed simultanously.  
The PianoController decides what to do with these events. For example, the controller decides if you can hear only one note at a time, if you can make a glissando etc. The controller can be modified or replaced to serve different purposes.  
The PianoView prepares the KeysView optically. The PianoController then works with the KeysView.  
  
I have just finished this project and haven't tested it a lot yet. If you find mistakes, also in this manual, I'd be glad to know.  
