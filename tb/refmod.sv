import "DPI-C" context function int adder(int a, int b);

class refmod extends uvm_component;
    `uvm_component_utils(refmod)
    
    tr_in tr;
    tr_out tr_o;
    integer a, b;
    uvm_analysis_imp #(tr_in, refmod) in;
    uvm_analysis_export #(tr_out) out;
    event begin_refmodtask;
    
    function new(string name = "refmod", uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr_o = tr_out::type_id::create("tr_o", this);
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            @begin_refmodtask;
            tr_o.data = adder(tr.A, tr.B);
            $display("%d",tr_o.data);
            out.write(tr_o);
        end
    endtask: run_phase

    virtual function write (tr_in t);
        tr = tr_in::type_id::create("tr", this);
        tr.copy(t);
        -> begin_refmodtask;
    endfunction


endclass: refmod