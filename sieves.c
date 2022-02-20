#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#define COLUMNS 6


// Tar emot en variabel som representerar primtalet som ska printas ut

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



// Funktionen ska skriva alla primtal från 2 till n genom att kalla på print_numbers och dess primtal
void print_sieves(int input)
{
    int array_size = input - 1;  // deklarerar arrayen som vi kommer att arbeta med (-1 för array börjar på 0,1,2 osv)
    char numbers[array_size];    // deklarerar lokal array

    for(int pos = 0; pos < array_size; pos++) // sätter arrayplatserna till 1 (True)
		{
      numbers[pos] = 1;
    }
    // kollar faktorerna upp till input^2 eftersom det är det sista nummret som kan upphöjt till 2 för att producera inputen
    for(int i = 2; i <= (int) sqrt(input); i++)
		{
      if(numbers[i] == 1){ // Kollar om värdet i arrayen redan är 0, dvs icke-primtal och behöver då inte test det talet
        for(int j = i*i; j <= input; j+=i)  //sätter verje multipel av det talet till noll i arraylistan enligt sieve teorin.
				{
          numbers[j] = 0; // markerar det som ett icke-primtal
        }
      }
    }

    //printar ut det sanna värderna från arrayen genom att roppa till print_numbers och börjar på index 2 då 0 och 1 ignoreras
    for(int i = 2; i <= array_size; i++)
		{
      if(numbers[i] == 1)
			{
        print_numbers(i);
      }
    }
}
// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[])
{
  if(argc == 2)
    print_sieves(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}
