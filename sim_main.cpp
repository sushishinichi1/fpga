#include "Vtop.h"
#include "verilated.h"
#include <iostream>

int main(){

    Vtop* top = new Vtop;

    uint32_t freq;
    std::cout << "freq > ";
    std::cin >> freq;

    top->f1=freq;
    top->f2=freq;
    top->f3=freq;
    top->f4=freq;
    top->update=1;

    top->clk=0; top->eval();
    top->clk=1; top->eval();

    top->update=0;
    top->gate=1;

    for(int i=0;i<480000;i++){
        top->clk=0; top->eval();
        top->clk=1; top->eval();
        std::cout<<top->wave_out<<"\n";
    }
}
