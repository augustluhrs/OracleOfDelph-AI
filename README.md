# Oracle of Delph.AI

a dance-to-divine text generator 

by Trisha Chhabra, August Luhrs, and Claire Yuan

made for CIID's Machine Learning for Interaction Design Class, July 2017, taught by [Andreas Refsgaard](https://github.com/andreasref) and [Gene Kogan](https://github.com/genekogan)


# Overview

Inspired by the Oracle of Delphi, the High Priestess who served as a conduit through which the God Apollo could speak, we've created a tool that allows a user to give their god or gods an offering in the form of a dance and receive a personalized message from the divine. 

The basic premise is -- a kinect paired with Wekinator tracks the user's dance (mainly just hand height) and will send a single message to a processing sketch that will run torch-rnn on a terminal, along with a unique seed text obtained from the dance. The RNN will then spit out a religious sounding message.

Our RNN was trained on five major religious texts (The KJ Bible, The Quran, The Gita, The Gospel of Buddha, and The Book of Mormon) for around 500 epochs (so, not long enough).

note: We had to get the duct-tape out when building this, since I (August) was running it on a windows computer connected to a cloud computer on [paper space](https://paperspace.com) -- there are much easier ways to do this on A) a computer powerful enough to run torch.rnn and B) a mac or linux based computer that can run OFX. Hopefully you can get the gist of the process here, and figure out how to adapt it to you (in a better way than I did...)

# Requirements
*it's a bit confusing keeping track of which tools need which O.S., so definitely make sure you can run all these

Hardware:
-- a Kinect (could be substituted with a webcam OSC app, check [ml4a](https://github.com/ml4a/ml4a-ofx))

Software:
-- [Torch.rnn](https://github.com/jcjohnson/torch-rnn)
-- [Processing](https://processing.org/download/)
-- [Wekinator](http://www.wekinator.org/downloads/)
-- [Weki Input Helper](http://www.wekinator.org/input-helper/)

# Installation


# Operation

