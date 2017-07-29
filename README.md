# Oracle of Delph.AI

a dance-to-divine text generator 

by Trisha Chhabra, August Luhrs, and Claire Yuan

made for CIID's Machine Learning for Interaction Design class, July 2017, taught by [Andreas Refsgaard](https://github.com/andreasref) and [Gene Kogan](https://github.com/genekogan)


# Overview

Inspired by the Oracle of Delphi, the High Priestess who served as a conduit through which the God Apollo could speak, we've created a tool that allows a user to give their god or gods an offering in the form of a dance and receive a personalized message from the divine. 

The basic premise is -- a kinect paired with Wekinator tracks the user's dance (mainly just hand height) and will send a single message to a processing sketch that will run torch-rnn on a terminal, along with a unique seed text obtained from the dance. The RNN will then spit out a religious sounding message.

Our RNN was trained on five major religious texts (The KJ Bible, The Quran, The Gita, The Gospel of Buddha, and The Book of Mormon) for around 500 epochs (so, not long enough).

note: We had to get the duct-tape out when building this, since I (August) was running it on a windows computer connected to a cloud computer on [paper space](https://paperspace.com) -- there are much easier ways to do this on A) a computer powerful enough to run torch.rnn and B) a mac or linux based computer that can run OFX. Hopefully you can get the gist of the process here, and figure out how to adapt it to you (in a better way than I did...)

# Requirements
*it's a bit confusing keeping track of which tools need which O.S., so definitely make sure you can run all these

Hardware:

- a Kinect (could be substituted with a webcam OSC app, check [ml4a](https://github.com/ml4a/ml4a-ofx))

Software:

- [Torch.rnn](https://github.com/jcjohnson/torch-rnn)

- [Processing](https://processing.org/download/)

- [Wekinator](http://www.wekinator.org/downloads/)

- [Weki Input Helper](http://www.wekinator.org/input-helper/)


# Installation and Operation

Download all software mentioned above -- I won't be going into how to use each of them, so check the individual pages for info.

Make sure you've taken the following files out of /TorchText and placed them in your torch-rnn directory:
```bash
all.h5
all.json
allcheck8_34000.t7
```

(all.txt is the original text file of the five works, if you're curious)




The Order of Operation:

A) Open `Kinect Joints` sketch, run it, and make sure kinect is tracking user's skeleton

B) Open Weki Input Helper (`firsttrain.inputproj`) and make sure "Send and Monitor" tab is open, check to see if OSC is coming in from Kinect

C) Open Wekinator (`firsttrain.wekiproj`) and make sure OSC is coming in from Input Helper. (Running this will be the last step)

D) Open `outputdancewords` (sorry about the name...) and run it

E) open terminal, navigate to torch-rnn 

so the final step is kinda wonky, but here's how we did it: 

once evertything is in place, have the user dance for a few seconds, then quickly press run on wekinator and then click on the terminal. almost immediately you should see the command appearing, and after it runs, the txt will pop up with the message.


# Final Notes

This was all built in about 24 hrs (including training of the RNN) by three people who learned these tools the couple of days before coming up with the project concept, so if you find any problems or have suggestions, please let us know!

And again, thanks to Andreas Refsgaard and Gene Kogan, who not only taught us how to use everything, but the processing scripts are basically just their orginals with a few minor adjustments to make them fit our project. Check out their work!

