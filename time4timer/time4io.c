 #include <stdint.h>
 #include <pic32mx.h>
 #include "mipslab.h"

 /* Shiftar bitarna 8 steg åt höger för att sedan maska ut det 4 LSB
    För att få värderna för SW1, SW2, SW3, SW4 */
 int getsw()
 {
   return ((PORTD>>8) & 0x000f);
 }
 /* Shiftar bitarna 5 steg åt höger för att sedan maska ut det 3 LSB
    För att få värderna för knapparna BTN2, BTN3, BTN4 */
 int getbtns()
 {
   return ((PORTD>>5) & 0x0007);
 }


