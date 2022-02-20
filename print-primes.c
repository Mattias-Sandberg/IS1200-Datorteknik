/*
 prime.c
 By David Broman.
 Last modified by Mattias Sandberg: 2022-02-10
 This file is in the public domain.
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define COLUMNS 6

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

// Funktionen print_numbers tar emot ett primtal som ska printas ut
int column_count = 0;
void print_numbers(int number)
{
  printf("%10d ", number);
  column_count++;
  if(column_count % COLUMNS == 0)
	{
    printf("\n");
  }
}

// funktionen ska printa ut alla primtal från 2 till (user input) genom att roppa på print_numbers och dess prime
void print_primes (int n)
{
	if (n<2)
  {
		printf("Saknas primtal mindre än: %10i", n);
	}
    else
		{
			int x = 2;
			for(x=2; x<n; x++)
      {
				if (is_prime(x) == 1 )
				{
				  print_numbers(x);
				}
			}
		}

}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
 int main(int argc, char *argv[])
 {
  if(argc == 2)
    print_primes(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}
