// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop.h"
#include "Vtop__Syms.h"

//==========

void Vtop::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtop::eval\n"); );
    Vtop__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("top.v", 1, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vtop::_eval_initial_loop(Vtop__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("top.v", 1, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void Vtop::_sequent__TOP__1(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_sequent__TOP__1\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    SData/*15:0*/ __Vdly__top__DOT__counter;
    SData/*15:0*/ __Vdly__top__DOT__env;
    // Body
    __Vdly__top__DOT__counter = vlTOPp->top__DOT__counter;
    __Vdly__top__DOT__env = vlTOPp->top__DOT__env;
    __Vdly__top__DOT__counter = (0xffffU & ((IData)(1U) 
                                            + (IData)(vlTOPp->top__DOT__counter)));
    if ((0U == (IData)(vlTOPp->top__DOT__counter))) {
        if (vlTOPp->gate) {
            if ((0xffffU > (IData)(vlTOPp->top__DOT__env))) {
                __Vdly__top__DOT__env = (0xffffU & 
                                         ((IData)(1U) 
                                          + (IData)(vlTOPp->top__DOT__env)));
            }
        } else {
            if ((0U < (IData)(vlTOPp->top__DOT__env))) {
                __Vdly__top__DOT__env = (0xffffU & 
                                         ((IData)(vlTOPp->top__DOT__env) 
                                          - (IData)(1U)));
            }
        }
    }
    if (vlTOPp->update) {
        vlTOPp->top__DOT__d4__DOT__phase = 0U;
        vlTOPp->top__DOT__d3__DOT__phase = 0U;
        vlTOPp->top__DOT__d2__DOT__phase = 0U;
        vlTOPp->top__DOT__d1__DOT__phase = 0U;
    } else {
        vlTOPp->top__DOT__d4__DOT__phase = (vlTOPp->top__DOT__d4__DOT__phase 
                                            + vlTOPp->top__DOT__d4__DOT__freq_reg);
        vlTOPp->top__DOT__d3__DOT__phase = (vlTOPp->top__DOT__d3__DOT__phase 
                                            + vlTOPp->top__DOT__d3__DOT__freq_reg);
        vlTOPp->top__DOT__d2__DOT__phase = (vlTOPp->top__DOT__d2__DOT__phase 
                                            + vlTOPp->top__DOT__d2__DOT__freq_reg);
        vlTOPp->top__DOT__d1__DOT__phase = (vlTOPp->top__DOT__d1__DOT__phase 
                                            + vlTOPp->top__DOT__d1__DOT__freq_reg);
    }
    vlTOPp->top__DOT__counter = __Vdly__top__DOT__counter;
    vlTOPp->top__DOT__env = __Vdly__top__DOT__env;
    if (vlTOPp->update) {
        vlTOPp->top__DOT__d4__DOT__freq_reg = vlTOPp->f4;
    }
    if (vlTOPp->update) {
        vlTOPp->top__DOT__d3__DOT__freq_reg = vlTOPp->f3;
    }
    if (vlTOPp->update) {
        vlTOPp->top__DOT__d2__DOT__freq_reg = vlTOPp->f2;
    }
    if (vlTOPp->update) {
        vlTOPp->top__DOT__d1__DOT__freq_reg = vlTOPp->f1;
    }
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

void Vtop::_eval(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_eval\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (((IData)(vlTOPp->clk) & (~ (IData)(vlTOPp->__Vclklast__TOP__clk)))) {
        vlTOPp->_sequent__TOP__1(vlSymsp);
    }
    // Final
    vlTOPp->__Vclklast__TOP__clk = vlTOPp->clk;
}

VL_INLINE_OPT QData Vtop::_change_request(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_change_request\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    return (vlTOPp->_change_request_1(vlSymsp));
}

VL_INLINE_OPT QData Vtop::_change_request_1(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_change_request_1\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vtop::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((gate & 0xfeU))) {
        Verilated::overWidthError("gate");}
    if (VL_UNLIKELY((update & 0xfeU))) {
        Verilated::overWidthError("update");}
}
#endif  // VL_DEBUG
