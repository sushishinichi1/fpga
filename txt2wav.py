import numpy as np
from scipy.io.wavfile import write

data = np.loadtxt("clean.txt")

audio = data - np.mean(data)
audio = audio / np.max(np.abs(audio))
audio = (audio * 32767).astype(np.int16)

write("out.wav",48000,audio)
