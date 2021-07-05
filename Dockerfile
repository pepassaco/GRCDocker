#Pablo Alvarez EA1FID

FROM ubuntu:21.04

RUN apt-get update


# Set tztime
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone



RUN apt install -y git cmake g++ libboost-all-dev libgmp-dev swig python3-numpy \
python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 \
liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins \
python3-zmq python3-scipy python3-gi python3-gi-cairo gir1.2-gtk-3.0 \
libcodec2-dev libgsm1-dev


RUN apt install -f
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:gnuradio/gnuradio-releases
RUN apt install -f
RUN apt install -y gnuradio
RUN apt install -y python3-gi gobject-introspection gir1.2-gtk-3.0

RUN apt install -y pulseaudio

ENTRYPOINT ["/usr/bin/gnuradio-companion"]
ENV HOME /root


RUN apt install -y python3-construct
RUN apt install -y python3-pip
RUN pip3 install --user --upgrade construct requests pybind11




WORKDIR $HOME
RUN git clone --recursive https://github.com/daniestevez/gr-satellites
WORKDIR gr-satellites
RUN git checkout maint-3.9
#RUN perl -i -p -e 's/Gnuradio "3.9"/Gnuradio "3.8"/g' CMakeLists.txt
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make -j $(nproc --all)
RUN make install
RUN ldconfig

RUN mkdir .gnuradio
WORKDIR .gnuradio
RUN echo "[audio_alsa]" > config.conf
RUN echo "nperiods = 32" > config.conf
RUN echo "period_time = 0.010" > config.conf
WORKDIR $HOME



# ESTO NO TIRA

##instalacion gr-ccsds
#WORKDIR $HOME
#RUN apt install -y libitpp-dev
#RUN git clone https://gitlab.com/librespacefoundation/gr-ccsds.git
#WORKDIR gr-ccsds
#RUN git checkout v0.0.1
##RUN sed -i 's/Gnuradio "3.7.2"/Gnuradio "3.7"/' CMakeLists.txt
#RUN mkdir build
#WORKDIR build
#RUN cmake ..
#RUN make -j $(nproc --all)
#RUN make install
#RUN ldconfig



WORKDIR $HOME

# Pulseaudio dependency to run alongside x11docker

RUN apt-get install -y pulseaudio

ENV PYTHONPATH=/usr/local/lib/python3/dist-packages/

ENTRYPOINT ["/usr/bin/gnuradio-companion"]
