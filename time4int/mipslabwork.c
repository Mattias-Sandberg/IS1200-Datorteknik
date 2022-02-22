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

int mytime = 0x0001; // Start tiden måste vara 1 så att ticks är lika med leds

int prime = 1234567;

char textstring[] = "text, more text, and even more text!";
/* Vi deklarerar pekarna som "volatile" eftersom vi vill undvika 
   kompileraren att optimera programmet vilket kan göra pekarna "static"*/
volatile int *tris_E;	
volatile int *port_E;

//Deklarerar timeoutcount och sätter variabeln till 0
int timeoutcount = 0;

/* Interrupt Service Routine */
void user_isr( void )
{
  if(IFS(0) & 0x0100)
  {
    // Kollar om det är avbrott 
    timeoutcount++;

    if(timeoutcount == 10)
    {
      time2string( textstring, mytime)
      display_string( 3, textstring );
      display_update();
      tick( &mytime );
      timeoutcount = 0;    
    }
   IFSCLR(0) = 0x100; // Rensar flaggan
  }
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
  *port_E = 0x00000000; // Sätter PORTE till 0 så att vi kan se tiksen bättre

  // uppgift e)
  TRISD = TRISD | 0x0fe0; // OR operation för att behålla bitarna 11-5
  
  // Uppgift 2.a) Initialisering av Timer2
  // Sätter ON-bit (bit 15) till noll för tt stoppa klockan
   
  T2CON = 0x0;
 
  // Andvänder Set-register för T2CON för att sätta prescaling till 1:256 (70 = 0111 0000)
  // Bit 6 till 4 är TCKPS som kontrollerar prescaling, 2³ = 8 configurations
  T2CONSET = 0x70;

  // Återställer timer register
  TMR2 = 0x0;

 /* Period register, Sätter värdet till (klock frekvens)/(prescaling)
    och dividerar sedan med 10 eftersom vi ska få en 100ms delay och vi har
    main time att uppdatera displayen bara var 10 avbrott (interuption).
    Timern tickar upp till detta värde och sedan sätts interrupt flag i IFS0 till 1. */
    
  PR2 = ((80000000 / 256) / 10);

  // Sätter ON-biten (bit nr: 15) till 1 för att starta klockan.
  T2CONSET = 0x8000;

  // Enabling interrupts
  // Interrupt enable control bit 8 är T2IF
  // sätter det till 1 för enable
  IECSET(0) = 0x100;
  
  // Interrupt prioritet. bit 4-2 är T2IP
  // Sätter prioritet 7 och sub-priority 3
  // bit 4-2: 0111 = 7
  // bit 1-0: 11 = 3
  // IPC2: 000111 11 = 0x1F
  IPCSET(2) = 0x1F;

  return;
}

/* This function is called repetitively from the main program */
void labwork( void )
{
  prime = nextprime(prime);
  display_string(0, itoaconv(prime));
  display_update();
}
