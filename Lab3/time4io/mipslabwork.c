/* mipslabwork.c

   This file written 2015 by F Lundevall
   Updated 2017-04-21 by F Lundevall

   This file should be changed by YOU! So you must
   add comment(s) here with your name(s) and date(s):

   This file modified 2017-04-31 by Ture Teknolog

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

int mytime = 0x0001; // Start tiden är 1 för att ticks ska vara lika med leds.

char textstring[] = "text, more text, and even more text!";

volatile int *tris_E;	/* Vi deklarerar pekarna som "volatile" eftersom vi vill undvika
			   kompileraren att optimera programmet vilket kan göra pekarna "static"*/
volatile int *port_E;

/* Interrupt Service Routine */
void user_isr( void )
{
  return;
}

/* Lab-specific initialization goes here */
void labinit( void )
{
  /* Tilldelas deras adresser då dom är deklarerade som "volatile".
     TRISE inehåller bitarna som bestämmer om portarna är INPUT/OUTPUT
     PORTE inehåller datan som bestämmer vilken INPUT/OUTPUT det är. */

  // Uppgift c)
  tris_E = (volatile int*) 0xbf886100; // Adressen till TRISE register
  port_E = (volatile int*) 0xbf886110; // Adressen till PORT register

  *tris_E = *tris_E & 0xffffff00; // Maskar ut det 8 LSB
  *port_E = 0x00000000; // Sätter PORTE till 0 (output till leds)

  // uppgift e)
  TRISD = TRISD | 0x0fe0; // OR operation för att behålla bitarna 11-5 (knapparna)

  return;
}

/* This function is called repetitively from the main program */
void labwork( void )
{
  int switches = getsw();
  int buttons = getbtns();

  /* Det tre knapparna behöver följande if satserna eftersom vi måste kunna pressa flera knappar
     i taget. Till exempel skulle knapp 4 och 3 (110) = 6. Så vi deklarerar 6 som ett tillstånd
     för båda knapparna eftersom koden exikverar båda if satserna. */


  // Knapp nr:2 (001)
  if(buttons & 1)
  {
    // Maskar ut bitarna som representerar den 10:de sekunden för att spara värdet på resten av tiden
    mytime = mytime & 0xff0f;
    // Tar värdet från switches, shiftar det till korrekt position och OR:ar dom med mytime
    mytime = (switches << 4) | mytime; // sätter rätt värde (tid) beroende på hur många switches som är nedtryckta
  }

  // Knapp nr:3 (010)
  if(buttons & 2)
  {
    // Maskar ut bitarna som representerar entals minuten
    mytime = mytime & 0xf0ff;
    // Tar värdet från switches, shiftar det till korrekt position och OR:ar dom med mytime
    mytime = (switches << 8) | mytime;
  }

   // Knapp nr:4 (100)
  if(buttons & 4)
  {
    // Maskar ut bitarna som representerar 10:de minuten
    mytime = mytime & 0x0fff;
    // Tar värdet från switches, shiftar det till korrekt position och OR:ar dom med mytime
    mytime = (switches << 12) | mytime;
  }

  delay( 1000 );
  time2string( textstring, mytime );
  display_string( 3, textstring );
  display_update();
  tick( &mytime );
  display_image(96, icon);

  // Uppgift d)
  *port_E = *port_E + 0x00000001; // Öka värdet per tick (leds som räknar i binärt)
}
