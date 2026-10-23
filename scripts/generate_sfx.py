"""Gera os efeitos sonoros dos minigames (assets/audio/sfx/*.wav).

Todos os sons são sintetizados aqui (senoides, ruído e envelopes), então
não dependem de licença de terceiros. Python puro, sem bibliotecas.

Uso:  python scripts/generate_sfx.py
"""
import math
import os
import random
import struct
import wave

RATE = 22050
OUT = os.path.join(os.path.dirname(__file__), '..', 'assets', 'audio', 'sfx')
random.seed(7)


def note(n):
    """Frequência de uma nota MIDI."""
    return 440.0 * 2 ** ((n - 69) / 12)


def env(i, n, attack=0.005, release=0.08):
    t = i / RATE
    dur = n / RATE
    a = min(1.0, t / attack) if attack > 0 else 1.0
    r = min(1.0, (dur - t) / release) if release > 0 else 1.0
    return max(0.0, min(a, r))


def tone(freq, dur, vol=0.5, wave_type='sine', decay=0.0, attack=0.005,
         release=0.06, vibrato=0.0, slide=0.0, harmonics=None):
    n = int(RATE * dur)
    out = []
    phase = 0.0
    for i in range(n):
        t = i / RATE
        f = freq * (1 + slide * t / dur) * (1 + vibrato * math.sin(2 * math.pi * 6 * t))
        phase += 2 * math.pi * f / RATE
        if wave_type == 'sine':
            s = math.sin(phase)
        elif wave_type == 'triangle':
            s = 2 / math.pi * math.asin(math.sin(phase))
        elif wave_type == 'square':
            s = 0.6 if math.sin(phase) >= 0 else -0.6
        else:
            s = math.sin(phase)
        if harmonics:
            for k, amp in harmonics:
                s += amp * math.sin(phase * k)
        e = env(i, n, attack, release)
        if decay:
            e *= math.exp(-decay * t)
        out.append(s * e * vol)
    return out


def noise(dur, vol=0.4, decay=20.0, lowpass=0.2):
    n = int(RATE * dur)
    out = []
    last = 0.0
    for i in range(n):
        t = i / RATE
        last = last + lowpass * (random.uniform(-1, 1) - last)
        out.append(last * vol * math.exp(-decay * t) * env(i, n, 0.002, 0.02))
    return out


def mix(*tracks, offsets=None):
    offsets = offsets or [0.0] * len(tracks)
    length = max(int(o * RATE) + len(t) for t, o in zip(tracks, offsets))
    out = [0.0] * length
    for t, o in zip(tracks, offsets):
        start = int(o * RATE)
        for i, s in enumerate(t):
            out[start + i] += s
    return out


def bell(freq, dur=0.6, vol=0.35):
    """Timbre de sino/cristal: fundamental + parciais inarmônicos."""
    return tone(freq, dur, vol, decay=5.0, attack=0.002, release=0.1,
                harmonics=[(2.0, 0.35), (3.01, 0.15), (4.2, 0.08)])


def save(name, samples):
    peak = max(1e-9, max(abs(s) for s in samples))
    gain = min(1.0, 0.9 / peak)
    os.makedirs(OUT, exist_ok=True)
    with wave.open(os.path.join(OUT, name + '.wav'), 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(b''.join(struct.pack('<h', int(s * gain * 32767)) for s in samples))
    print('ok', name, f'{len(samples) / RATE:.2f}s')


# --- Interface -------------------------------------------------------------
save('click', mix(tone(1800, 0.03, 0.3, decay=80, release=0.01), noise(0.02, 0.15, 120, 0.6)))
save('pop', tone(520, 0.09, 0.6, slide=1.4, decay=25, release=0.02))
save('whoosh', noise(0.25, 0.5, 6, 0.08))

# --- Cartas / acertos ------------------------------------------------------
save('card_flip', mix(noise(0.08, 0.5, 30, 0.35), tone(900, 0.04, 0.15, decay=60), offsets=[0, 0.01]))
save('match', mix(bell(note(76), 0.45), bell(note(83), 0.55), offsets=[0, 0.09]))
save('mismatch', mix(tone(220, 0.12, 0.35, 'triangle', release=0.04),
                     tone(185, 0.16, 0.35, 'triangle', release=0.06), offsets=[0, 0.12]))
save('correct', mix(bell(note(84), 0.5, 0.4), bell(note(91), 0.5, 0.25), offsets=[0, 0.05]))
save('wrong', tone(200, 0.28, 0.4, 'triangle', slide=-0.35, release=0.08, vibrato=0.02))
save('star', mix(*[bell(note(88 + k * 3), 0.35, 0.22) for k in range(3)], offsets=[0, 0.06, 0.12]))
save('combo', mix(*[tone(note(72 + k * 4), 0.12, 0.3, 'triangle', decay=10) for k in range(4)],
                  offsets=[0, 0.05, 0.1, 0.15]))

# --- Fim de jogo -----------------------------------------------------------
fanfare = [72, 76, 79, 84]
save('victory', mix(*[tone(note(n), 0.5 if k == 3 else 0.16, 0.32, 'triangle', decay=2.5,
                           harmonics=[(2, 0.2)]) for k, n in enumerate(fanfare)],
                    bell(note(96), 0.9, 0.2),
                    offsets=[0, 0.13, 0.26, 0.39, 0.39]))
save('game_over', mix(*[tone(note(n), 0.3, 0.32, 'triangle', decay=3) for n in (67, 63, 60)],
                      offsets=[0, 0.22, 0.44]))

# --- Quebra-cabeça / labirinto ---------------------------------------------
save('snap', mix(noise(0.05, 0.6, 60, 0.5), tone(330, 0.08, 0.4, decay=40, release=0.02)))
save('pickup', tone(660, 0.07, 0.3, slide=0.5, decay=20, release=0.02))
save('step', mix(noise(0.04, 0.35, 80, 0.15), tone(140, 0.04, 0.25, decay=60)))
save('bump', mix(tone(90, 0.12, 0.6, slide=-0.3, decay=25), noise(0.06, 0.3, 50, 0.1)))
save('gem', mix(bell(note(88), 0.35, 0.35), bell(note(95), 0.4, 0.3), offsets=[0, 0.07]))

# --- Colorir ---------------------------------------------------------------
save('paint', mix(noise(0.12, 0.35, 18, 0.12), tone(300, 0.14, 0.3, slide=0.8, decay=14)))
save('erase', noise(0.15, 0.4, 14, 0.5))

# --- Notas dos cristais (pentatônica, timbre de sino) ----------------------
for k, n in enumerate([60, 62, 64, 67, 69, 72, 74, 76, 79]):
    save(f'note_{k}', bell(note(n + 12), 0.55, 0.45))
