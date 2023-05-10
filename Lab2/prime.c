/*
 prime.c
 By David Broman.
 Last modified by Mattias Sandberg: 2022-02-10
 This file is in the public domain.
*/

#include <stdio.h>
#include <time.h>

int is_prime(int n)
{
   int r; //räknare

   if(n == 1 || n == 0)         // kollar om n är 1 eller 0 och printar då ut 0
      return 0;

   for(r = 2; r <= n-1; r++)    /*Kollar om n kan delas lika med något tal,
                                som är mindre eller lika med n-1*/
   {
     if(n % r == 0)             // Om resten med efter divison är 0, returnera 0
     {
       return 0;
     }
   }
   return 1;                    // Annars returnera 1
 }



 int main(void){
   printf("%d\n", is_prime(1));  // 11 is a prime.      Should print 0.
   printf("%d\n", is_prime(383)); // 383 is a prime.     Should print 1.
   printf("%d\n", is_prime(0)); // 987 is not a prime. Should print 0.
}
