![image](https://github.com/himanshudutta11/rfsoc_nrssb/assets/121915091/6978d9eb-dfa8-4d92-945b-19c1431a7172)

Folder organization:

1. IP Repo - rfsoc_nrssb/boards/ip/iprepo at main · himanshudutta11/rfsoc_nrssb (github.com)
2. TCL scripts : rfsoc_nrssb/boards/RFSoC2x2/rfsoc_nrssb at main · himanshudutta11/rfsoc_nrssb (github.com)
3. Bitstream - rfsoc_nrssb/boards/RFSoC2x2/rfsoc_nrssb/bitstream.zip at main · himanshudutta11/rfsoc_nrssb (github.com)
4. Python files for PYNQ framesworks - rfsoc_nrssb/rfsoc_nrssb at main · himanshudutta11/rfsoc_nrssb (github.com)
5. Jupyter Notebooks - rfsoc_nrssb/notebooks at main · himanshudutta11/rfsoc_nrssb (github.com)


The steps involved:

1. Simulink Model – SSB Detect
   ![image](https://github.com/himanshudutta11/rfsoc_nrssb/assets/121915091/a916aa58-6f45-4f62-b5a2-28f211c963ca)

2. HDL Code generation
   ![image](https://github.com/himanshudutta11/rfsoc_nrssb/assets/121915091/4ae21e45-2480-4156-a708-0427d89fa206)

3. IP Core generation
   ![image](https://github.com/himanshudutta11/rfsoc_nrssb/assets/121915091/bb8a9916-509d-45f0-a340-39d9bb04a891)

4. Block Design and interconnection
   ![image](https://github.com/himanshudutta11/rfsoc_nrssb/assets/121915091/52887869-9e79-42be-8b38-286fc4d0e1ab)

5. Bitstream generation
 Bitstream is generated through the script - rfsoc_nrssb/boards/RFSoC2x2/rfsoc_nrssb/make_bitstream.tcl
   
6. Invoking IPs from PYNQ framework
