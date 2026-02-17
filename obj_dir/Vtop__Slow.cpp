// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop.h"
#include "Vtop__Syms.h"

//==========

VL_CTOR_IMP(Vtop) {
    Vtop__Syms* __restrict vlSymsp = __VlSymsp = new Vtop__Syms(this, name());
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vtop::__Vconfigure(Vtop__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-12);
    Verilated::timeprecision(-12);
}

Vtop::~Vtop() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = NULL);
}

void Vtop::_initial__TOP__2(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_initial__TOP__2\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->top__DOT__counter = 0U;
    vlTOPp->top__DOT__d1__DOT__freq_reg = 0U;
    vlTOPp->top__DOT__d2__DOT__freq_reg = 0U;
    vlTOPp->top__DOT__d3__DOT__freq_reg = 0U;
    vlTOPp->top__DOT__d4__DOT__freq_reg = 0U;
    vlTOPp->top__DOT__env = 0U;
    vlTOPp->top__DOT__d1__DOT__phase = 0U;
    vlTOPp->top__DOT__d2__DOT__phase = 0U;
    vlTOPp->top__DOT__d3__DOT__phase = 0U;
    vlTOPp->top__DOT__d4__DOT__phase = 0U;
}

void Vtop::_settle__TOP__3(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_settle__TOP__3\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->wave_out = (0x3ffU & (((0xffU & (((((0xffU 
                                                 & ((0x80000000U 
                                                     & vlTOPp->top__DOT__d1__DOT__phase)
                                                     ? 
                                                    (~ 
                                                     (vlTOPp->top__DOT__d1__DOT__phase 
                                                      >> 0x18U))
                                                     : 
                                                    (vlTOPp->top__DOT__d1__DOT__phase 
                                                     >> 0x18U))) 
                                                + (0xffU 
                                                   & ((0x80000000U 
                                                       & vlTOPp->top__DOT__d2__DOT__phase)
                                                       ? 
                                                      (~ 
                                                       (vlTOPp->top__DOT__d2__DOT__phase 
                                                        >> 0x18U))
                                                       : 
                                                      (vlTOPp->top__DOT__d2__DOT__phase 
                                                       >> 0x18U)))) 
                                               + (0xffU 
                                                  & ((0x80000000U 
                                                      & vlTOPp->top__DOT__d3__DOT__phase)
                                                      ? 
                                                     (~ 
                                                      (vlTOPp->top__DOT__d3__DOT__phase 
                                                       >> 0x18U))
                                                      : 
                                                     (vlTOPp->top__DOT__d3__DOT__phase 
                                                      >> 0x18U)))) 
                                              + (0xffU 
                                                 & ((0x80000000U 
                                                     & vlTOPp->top__DOT__d4__DOT__phase)
                                                     ? 
                                                    (~ 
                                                     (vlTOPp->top__DOT__d4__DOT__phase 
                                                      >> 0x18U))
                                                     : 
                                                    (vlTOPp->top__DOT__d4__DOT__phase 
                                                     >> 0x18U)))) 
                                             >> 2U)) 
                                   * (IData)(vlTOPp->top__DOT__env)) 
                                  >> 6U));
}

void Vtop::_eval_initial(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_eval_initial\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->__Vclklast__TOP__clk = vlTOPp->clk;
    vlTOPp->_initial__TOP__2(vlSymsp);
}

void Vtop::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::final\n"); );
    // Variables
    Vtop__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vtop::_eval_settle(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_eval_settle\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__3(vlSymsp);
}

void Vtop::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_ctor_var_reset\n"); );
    // Body
    clk = VL_RAND_RESET_I(1);
    gate = VL_RAND_RESET_I(1);
    f1 = VL_RAND_RESET_I(32);
    f2 = VL_RAND_RESET_I(32);
    f3 = VL_RAND_RESET_I(32);
    f4 = VL_RAND_RESET_I(32);
    update = VL_RAND_RESET_I(1);
    wave_out = VL_RAND_RESET_I(16);
    top__DOT__env = VL_RAND_RESET_I(16);
    top__DOT__counter = VL_RAND_RESET_I(16);
    top__DOT__d1__DOT__phase = VL_RAND_RESET_I(32);
    top__DOT__d1__DOT__freq_reg = VL_RAND_RESET_I(32);
    top__DOT__d2__DOT__phase = VL_RAND_RESET_I(32);
    top__DOT__d2__DOT__freq_reg = VL_RAND_RESET_I(32);
    top__DOT__d3__DOT__phase = VL_RAND_RESET_I(32);
    top__DOT__d3__DOT__freq_reg = VL_RAND_RESET_I(32);
    top__DOT__d4__DOT__phase = VL_RAND_RESET_I(32);
    top__DOT__d4__DOT__freq_reg = VL_RAND_RESET_I(32);
}
