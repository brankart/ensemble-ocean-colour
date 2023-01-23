#!/bin/bash

# Directory settings

sdir="$HOME/github/ensemble-ocean-colour/scripts"  # Script directory
wdir="$WORK/ensemble-ocean-colour"                 # Working directory

datadir="$STORE/../uzx13pp/Observations/OCEANCOLOUR_GLO_CHL_L3_REP_OBSERVATIONS_009_085/2019" # Observation data directory
priordir="$wdir/PriorData"               # Prior ensemble directory 

indicators_dir="$HOME/github/ensemble-ocean-colour/diag-NEMO-PISCES" # Directory with code to compute indicators

figdir="$wdir/Figures"

# Variable, time and grid configuration

list_periods="20190220_20190321 20190322_20190420 20190421_20190520 20190521_20190619"   # list of periods from model outputs to use

list_filetypes="ptrc diad diag"  # list of all filetypes (with indicators in diag)
list_variables[1]="CHL,NO3,POC,ZOO,ZOO2"  # list of variables to extract from first filetype (with comas)
list_variables[2]="PAR"          # list of variables to extract from second filetype (with comas)
list_variables[3]="pocF100,TrophicEfficiencyI"         # list of indicators (with comas)

simulation_name="iORCA025_1d"    # name of simulation (+output frequency)
region_name="NabePAP"            # name of region name in model filenames
refday="18262.5"                 # reference day to convert model time into Julian days

imin="0"        # BATS=0  # PAP=37 # Nabe=21
imax="39"       # BATS=39 # PAP=76 # Nabe=60
jmin="0"        # BATS=4  # PAP=9  # Nabe=77
jmax="39"       # BATS=43 # PAP=48 # Nabe=116
kmin="0"
kmax="31"       # 31 corresponds to the 221.441 m. ; 74 is the full depth
tmin="24"       # first day in total time period
tmax="116"      # last in total time period

# Observation database extraction parameters

data_scenario="full"  # Name of the scenario to be prepared (full, odd, or even)

data_product="L3"
data_var="CHL"
data_year="2019"
data_mlist="03 04 05 06"  # List of months to use

data_imin="3550"  # lon_min
data_imax="3850"  # lon_max
data_istp="3"
data_jmin="930"   # lat_min
data_jmax="1130"  # lat_max
data_jstp="3"

data_dayshift="18262" # day shift to fit model time reference

# Observation parameters

obs_scenario="full" # Name of the scenario to be prepared
jday_first="none"   # First time of observation to use (put "none" to take all data)
jday_last="none"    # Last time of observation to use (put "none" to take all data)
oestdr="0.3"        # Observation error standard deviation (fraction of obs value)

# Prior ensemble parameters

ens_size="0040"         # Prior ensemble size (in 4 digits)
ens_mem1="2"            # Index of first ensemble member to use

blocksize="180420"      # State vector block size for parallel computation (1/160)

# MCMC sampler localization parameters

loc_lmax="200"          # Maximum degree of spherical harmonics in localizing ensemble
loc_time_scale="10."    # Localization time scale (in days) ! multiplied by sqrt(mult=6)
loc_radius="0.7"        # Localization radius (in degree)   ! multiplied by sqrt(mult=6)
loc_dir_tag="200-100-070"   # Tag in directory name

# Definition of the observational update experiment

expt="full01"             # Name of the experiment
scenario_used="full"       # Name of the observation scenario to use

oestdfile="oestd"          # File tag to use as observation error std
oestdfile="oestdr"         # File tag to use as observation error std
obserror_type="lognormal"  # observation error probability distribution (lognormal, gamma) ! use oestdr file tag

# MCMC sampler parameters

upd_size="0040"            # Updated ensemble size
niter="30000"              # Number of iterations

scal_mult_1="1"            # Multiplicity of 1st scale (in Schur products)
scal_mult_2="6"            # Multiplicity of 2nd scale (in Schur products)

oestd_inflation="1."       # Observation error inflation factor

# LETKF parameters

loc_efd_space="4.5"        # localization e-folding distance (in grid points)
loc_efd_time="7.5"         # localization e-folding time (in days)
loc_cut_space="12"         # localization cutting distance (in grid points)
loc_cut_time="20"          # localization cutting time (in days)

minoestd="0.1"             # Minimum obs error std after anamorphosis

# Diagnostic parameters
exptdiag="full01"         # Experiment to diagnose
scenario_verif="vfull"    # Name of the observation scenario to use as verification data

vdiag="CHL"  # Variable for the diagnsotic of timeseries
fdiag="ptrc" # Filetag for the diagnsotic of timeseries
idiag="19"   # Location for the diagnsotic of timeseries
jdiag="19"   # Location for the diagnsotic of timeseries
kdiag="1"    # Location for the diagnsotic of timeseries
ntseries="40"  # Number of timeseries to plot
ltseries="prior full01 ${exptdiag}" # List of experiments to plot

vdiag1="CHL"     # Variable for the diagnsotic of scatterplot (variable 1)
fdiag1="ptrc"    # Filetag for the diagnsotic of scatterplot (variable 1)
vdiag2="pocF100" # Variable for the diagnsotic of scatterplot (variable 2)
fdiag2="diag"    # Filetag for the diagnsotic of scatterplot (variable 2)
tdiag="73"       # Index of time for the diagnostic of scatterplot

lsplot="noobs full01 ${exptdiag}"
