import "DPI-C" context function int sum(int a, int b);

class refmod extends uvm_component;
    `uvm_component_utils(refmod)
    
    tr_in tr_in;
    tr_out tr_out;
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
        tr_out = tr_out::type_id::create("tr_out", this);
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            @begin_refmodtask;
            tr_out.data = sum(tr_in.A, tr_in.B);
            out.write(tr_out);
        end
    endtask: run_phase

    virtual function write (tr_in t);
        tr_in = tr_in::type_id::create("tr_in", this);
        tr_in.copy(t);
        -> begin_refmodtask;
    endfunction


endclass: refmod