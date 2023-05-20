// Global variables

#define AUDIO_RESOLUTION
#define CTRL_RESOLUTION

enum WAVE_SHAPE {
        SINE,
        TRIANGLE,
        RAMP,
        SAWTOOTH,
        SQUARE,
};

enum EFFECT_LIST {
        TREMOLO,
};


struct effect_param {
         int *x; // input location
         int *c; // Coefficient location
         int *p; // Parameter location
};

struct pedal_state {
        int bypassed : 1;
        int chainActive : 1;

        int *current_effect;
        struct effect_param *current_param;
};

int main(void) {

        // Initial setup


        // Main loop
        while(1) {
                // Button processing
                // Effect processing
        }
}

// Button control

// System administration

// Effect processing
int fir(int *x, int *c, unsigned int size)
{
        int y = 0;

        for (int i = 0; i < size; i+=1) {
                y = x[i] * c[i] + y;
        }

        return y;
}


int iir(int *x, int *x_c, unsigned int x_size, int *y, int *y_c, unsigned int y_size)
{
        int o = 0;

        for (int i = 0; i < x_size; i+=1) {
                o = x[i] * x_c[i] + o;
        }

        for (int i=0; i < y_size; i+=1) {
                o = y[i] * y_c[i] + o;
        }

        return o;
}

int distortion(int *x, int clip, enum CLIP_TYPE,


int tremolo(int x, int n)
{
        int y = 0;
        int w = 0;

        y = (x + x * n * w) / (CTRL_RESOLUTION + n);

        return y;
}


int wave_gen() {
        return 0;
}
