#include<iostream>

using namespace std;

long long int ccw(long long int x2, long long int * x19, long long int * x20, 
		long long int * x21);
long long int cw(long long int x2, long long int * x19, long long int * x20, 
		long long int * x21);
int main(){

	long long intint x2 = 0;
	long long int * x19 = new long long int[16];
	long long int * x20 = new long long int[16];
	long long int * x21 = new long long int[16];
	

	int x15 = 255;
	*x19 = x15;
	*x20 = x15;
	*x21 = x15;
	
	int x4 = 10;
	x15 = x4;

	loop:
		x19++;
		*x19 = x15;
		x15 -= 1;
		if (x15 != 0){
			goto loop;
		}
		else{
			goto chanoi;
		}

	chanoi:
		if (*x19 == 255){
			goto stop;
		}
		x2 = 2*ccw(x2) + 1;
	stop:
	
		delete[] x19;
		delete[] x20;
		delete[] x21;		

}

long long int ccw
