import wave

SCALE = 50000
samples=[]
current=0
last_time=0

with open("wave.vcd") as f:
    for line in f:
        if line.startswith("#"):
            t=int(line[1:])
            duration=t-last_time
            samples += [current]*duration
            last_time=t

        elif line.startswith("1%"):
            current=30000

        elif line.startswith("0%"):
            current=-30000

wav=wave.open("out.wav","w")
wav.setnchannels(1)
wav.setsampwidth(2)
wav.setframerate(44100)

for s in samples:
    wav.writeframesraw(int(s).to_bytes(2,"little",signed=True))

wav.close()
print("done")
