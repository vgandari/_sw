### Navigating a code base

- Typically,

  - `bin`: binary/executable files (leave out of commits)
  - `data`: input/shared data
  - `etc`: You can find references to "et cetera" in old Bell Labs UNIX manuals and so on – nowadays it's used only for system configuration, but it used to be where all the stuff that didn't fit into other directories went ([UNIX Stack Exchange](http://unix.stackexchange.com/a/5669/147092)). I use `etc` to put the files I use that came from other places.
  - `include`: contains generated files
  - `lib`: contains header files and source code for user defined libraries
  - `matlib`: user defined MATLAB libraries
  - `models`: may contain some source code or lookup tables used for simulation in order to keep them separate from the rest of the source code; subfolders named by discipline (e.g., `aero`, `prop`, `dyn`, `kin`)
  - `src`: contains source code that gets compiled
      - `debug`: debug files
      - `scripts`: contains OS scripts or interpreted language scripts
      - `test`: test scripts/objects, etc.
- `usr`: contains files used only by the user; may contain driver files (scripts that provide inputs to executables, especially for batch processing), output for a specific user (if running executables on a network where other output data is shared; e.g. `data`, `log`), plotting scripts, etc.
      - `log`: log files (output)
      - `data`: datasets (output)
