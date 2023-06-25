# Introduction

In the **SHA3_Kyber768** repository you can find an example of a post-quantum cryptographic (PQC) hardware implementation for the primitives required by CRYSTALS-Kyber 768. 
If you are using this accelerator, please refers to:

> Hardware architecture for CRYSTALS-Kyber post-quantum cryptographic SHA-3 primitives, Alessandra Dolmeta, Maurizio Martina and Guido Masera

# Abstract
Once powerful enough quantum computers become feasible, many of the regularly used cryptosystems will be completely useless. Thus, designing quantum-safe cryptosystems to replace current algorithms is more crucial than ever. This paper presents the hardware implementation of one of the fundamental building blocks of all post-quantum cryptographic (PQC) algorithms, which are PQC-primitives, having NIST-PQCfinalists CRYSTALS-Kyber algorithm as a target. This work analyzes Keccak sponge function and the four SHA-3 algorithms used in CRYSTALS-Kyber, realizing the correct processing and handling of input information and integrating the four standards into one implementation for Kyber-III level of security. The synthesis results are provided for 65-nm technology, while Artix-7 XC7A75-3 is chosen as the implementation platform. The efficiency and the performance of the proposed architecture are compared in terms of area, frequency, clock cycles, and efficiency with the state-of-the-art.
