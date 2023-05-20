# Audio spectrum
https://www.teachmeaudio.com/mixing/techniques/audio-spectrum

|===========|===========|================|
| Fmin (Hz) | Fmax (Hz) |      Name      |
|===========|===========|================|
|   20      |   60      | Sub Bass       |
|   60      |   250     | Bass           |
|   250     |   500     | Low Midrange   |
|   500     |   2000    | Midrange       |
|   2000    |   4000    | Upper Midrange |
|   4000    |   6000    | Presence       |
|   6000    |   20000   | Brillance      |
|===========|===========|================|

# Tuner

# Signal generator
La fréquence d'échantillonnage des samples est de:
Fsample = 48000Hz -> Tsample = 20.8µs

Les generateurs de signaux ont un T >> Tsample, donc on peut faire:
Après un nombre x = T/Tsample -> update_signal

# Effects
clip fn: tanh, arctan
## Distortion Effect
https://manual.audacityteam.org/man/distortion.html
### Gain Boost
$$ y(t) = A \times x(t) $$

pas de tone, si sa clip rip

### Distortion
mid clipping

$$ y(t) = A \times x(t) $$

### Overdrive
clip très bas

### Fuzz
le clipping floor est très bas (

### Blues Driver
soft clipping + clean overdrive

Clip symétrique /assymétrique

https://en.wikipedia.org/wiki/Tone_control_circuit
Tone: Attenuer Bass / Treble frequency

## Dynamic Effect
### Compressor
Parameters:
Level: Détermine le niveau maximal du input signal et ajuste le gain pour que cette valeur soit tjrs atteinte
Tone: EQ
Attack: Lorsqu'une nouvelle note est détecté, le gain est réinitialisé à cette valeur
Sustain: Détermine le gain maximal qu'on peut donner au signal, ce qui fait en sorte que les sons très faibles ne fadent pas

Détecte l'amplitude du son et ajuste dynamiquement le gain pour pas qu'il fade out ou dépasse le max

## Modulation
### Phaser
Rate: Sweep faster/slower (control la frequence du lfo)
Depth: Effect plus intense (gain input/effect)
Resonance: met de l'emphase sur les tons du sweep (TBD) EQ?
Modes : Nombre d'étages de phase shifts (nb all pass filters)
https://www.soundonsound.com/sound-advice/q-whats-difference-between-phasing-and-flanging

### Chorus
https://www.hobby-hour.com/guitar/chorus_effects.php

Controls:
Delay: Le délai minimal du la ligne de délai: 20ms - 30ms expérimentalement (D)
Depth: la variation du lfo
Rate: Frequence du LFO ~0-5ms expérimentalement
Wave : On peut modifier la shape du lfo pour avoir des framings différents

$$ y(t) = x(t) + x(t + Δt)$$
$$ Δt = delay_{min} + \frac{delay_{max} - delay_{min}}{D_{max}} \cdot D + w(t)$$
Ici Δt vari statiquement selon le paramètre D du minimal au max, puis ensuite un lfo vient faire varier ce delai dynamiquement

### Flanger
https://wiki.analog.com/resources/tools-software/sigmastudio/toolbox/adialgorithms/flanger

### Tremolo
Parameters:
Depth: Intensity of the effect (N)
Rate : Frequency of the waveform
Wave : Waveform of the LFO (w(t)): Sawtooth

Equation:
$$ y(t) = x(t) \cdot ( \frac{1 + N \cdot w(t)}{1 + N} ) $$

Algorithm
var y, x, w
var t

y ← x * w
y ← y * N
t ← 1 + N
y ← y / t
y ← y + x
analyse: 3 variables

### Harmonic tremolo

$$ y(t) = H_f(t) + L_f(t)$$
$$ H_f(t) = HPF(x(t)) \cdot w(t+90 \degree ) $$
$$ L_f(t) = LPF(x(t)) \cdot w(t-90 \degree ) $$

### Vibrato
$$ y(t) = x(t) \cdot e^{jω(t)t} $$
$$ e^{jω(t)t} = cos(ω(t)t) + j\cdot sin(ω(t)t) $$
$$ ω(t) = tri(t) $$

Technique: https://sound-au.com/project204.htm
x(t) doit etre à 0 deg pour cos et 90 pour sin (All pass filter)
peut utiliser -45 et +45 pour avoir symétrie
la frequence w(t) doit etre linéaire


## Time Effect
### Delay
https://wiki.analog.com/resources/tools-software/sharc-audio-module/baremetal/delay-effect-tutorial

### Reverb
### Octave Reverb


## Frequency Effect
Avoir un circuit FFT qui analyse constament

### Equalizer
Modifie l'amplitude du signal FFT

### Envelope Filter
https://www.hochstrasserelectronics.com/news/introductiontoenvelopefilters
Tone controllé par amplitude du signal

Envelope detector -> audio filter

### Wah Wah
mode auto: avoir un LFO qui controle le va et vien

### Fshift
#### Octaver
ajoute un octave avant/après
#### Harmonizer
ajoute n'importe quel shift avant/apres
#### Pitch shifter
modifie le pitch de la guitare


## Others
### Noise gate
Si signal > min_treshold:
signal = 0

### Loopers

