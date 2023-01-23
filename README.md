# Ensemble analysis of ocean colour observations

This repository provide a collection of shell scripts to produce a ensemble analysis (3D+time)
of ocean colour observations, using prior statistics from an ensemble ocean ecosystem simulation.

### Software required

These scripts make use of the SESAM toolbox (https://github.com/brankart/sesam),
which requires the EnsDAM (https://github.com/brankart/ensdam) libraries.
The installation of these software also requires
a FORTRAN-90 compiler and the NetCDF library (with f90 support).

The scripts also make use of the NCO NetCDF operators.

### Scripts

The scripts can be used to perform the following operations
(see the README file in the script directory for more details):
 * prepare configuration (grid, mask, ...);
 * prepare prior ensemble (unconstrained by observations);
 * prepare ocean colour observations;
 * sample the posterior ensemble (conditioned to observations, using an MCMC sampler);
 * diagnose the posterior ensemble (RMS misfit, probabilistic scores, ...).

### Input data

The scripts use the following datasets:

* L3 ocean colour products. This corresponds to the tag OCEANCOLOUR\_GLO\_CHL\_L3\_REP\_OBSERVATIONS\_009\_085 catalog (https://marine.copernicus.eu/). These data are used as observations to constrain the prior ensemble.

* A prior ensemble simulation of the ocean ecosystem. These data are used as a prior ensemble (describing the prior probability distribution).

### Parameters

The parameters are specified in the script 'param.ksh', which is sourced in all other scripts so that they all see the same parameters. The parameters include:
 * directory settings;
 * grid and mask configuration;
 * observation parameters (time window, observation error,...);
 * multiscale prior ensemble parameters (size, localization scale,...);
 * MCMC sampler parameters (sample size, number of iterations, localization,...);
 * diagnostic parameters.

### Output data

The output is an ensemble of possible solutions (in 3D+time), including any combination of variables that are present in the prior ensemble.
