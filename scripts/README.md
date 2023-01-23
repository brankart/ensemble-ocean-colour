# Description of the shell scripts

The scripts use SESAM and NCO tools to perform operations on the data. Files and directories containing intermediate data have standardized names defined in the scripts, which depend on the name of the experiment defined in the parameters. Parallelization and batch directives in the scripts may need to be adjusted to the system.

Each script performs one task on the data. They must be run successively to perform the ensemble analysis. They come in 5 categories:

### Prepare configuration (grid, mask, ...)

 * <i>param.bash</i>: Define all parameters of the experiment.

 * <i>prepare_config.bash</i>: Prepare SESAM configuration: mask and parameter files.

### Prepare multiscale prior ensemble (unconstrained by observations)

 The prior ensemble is constructed using a prior ensemble simulation:

 * <i>prepare_prior_ensemble.bash</i>: Extract prior ensemble from simulation data (in native grid and format).

 * <i>convert_prior_ensemble.bash</i>: Convert prior ensemble into unstructured format (.cpak)

 * <i>calc_quantiles.bash</i>: Compute quantiles of the prior ensemble (in unstructured format).

 * <i>calc_anam.bash</i>: Compute anamorphosis of the prior ensemble (in unstructured format).

### Prepare ocean color observations

 * <i>prepare_obs_database.bash</i>: Prepare observation database (in native format).

 * <i>prepare_obs.bash</i>: Prepare observations to use in the experiment.

### Sample the posterior ensemble with the MCMC sampler

 * <i>prepro_mcmc.bash</i>: Center-reduce observations using prior mean and std and compute obs equivalent to ensembles.

 * <i>update_mcmc.bash</i>: Apply MCMC sampler to sample the posterior probability distribution (conditioned to observations).

 * <i>calc_anam_inv.bash</i>: Apply inverse anamorphosis transformation to the resulting MCMC sample.

 * <i>convert_posterior_ensemble.bash</i>: Convert posterior ensemble back to structured format (.nc)

### Compute the posterior ensemble with the LETKF algorithm

 * <i>calc_anam_obs.bash</i>: Compute anamorphosis of observations -> observation sample in transformed space

 * <i>letkf_localization.bash</i>: Prepare localization for the LETKF algorithm

 * <i>update_letkf.bash</i>: Apply the LETKF algorithm to compute the posterior ensemble

 * <i>calc_anam_inv.bash</i>: Apply inverse anamorphosis transformation to the resulting MCMC sample.

 * <i>convert_posterior_ensemble.bash</i>: Convert posterior ensemble back to structured format (.nc)

### Diagnose the posterior ensemble

 * <i>calc_score.bash</i>: Compute scores for the updated ensemble (CRPS and rank histogram).

 * <i>calc_score_prior.bash</i>: Compute scores for the prior ensemble (CRPS and rank histogram).

 * <i>diag_quantiles.bash</i>: Compute selected quantiles for the updated ensemble.

 * <i>diag_quantiles_prior.bash</i>: Compute selected quantiles for the prior ensemble.

 * <i>diag_timeseries.bash</i>: Extract ensemble of timeseries from the updated ensemble.

 * <i>diag_timeseries_prior.bash</i>: Extract ensemble of timeseries from the prior ensemble.

 * <i>diag_profiles.bash</i>: Extract profile at a given location/date from the updated ensemble.

 * <i>diag_profiles_prior.bash</i>: Extract profile at a given location/date from the prior ensemble.

 * <i>diag_scatterplot.bash</i>: Extract scatterplot at a given location/depth/date from the updated ensemble.

 * <i>diag_scatterplot_prior.bash</i>: Extract scatterplot at a given location/depth/date from the prior ensemble.

### Operations related to ecosystem indicators

 * <i>compute_indicators.bash</i>: Compute ecosystem indicators from NEMO/PISCES model outputs using the PISCES-DIAG package.

 * <i>diag_phenology.bash</i>: Diagnose phenology for the updated ensemble.

 * <i>diag_phenology_prior.bash</i>: Diagnose phenology for the prior ensemble.

 * <i>diag_qunatiles_phenology.bash</i>: Compute quantiles for phenology for the updated ensemble.

 * <i>diag_qunatiles_phenology_prior.bash</i>: Compute quantiles for phenology for the prior ensemble.

