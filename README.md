ParticleFilterResults
---------------------

This archive contains the BEAST 2 XML and R scripts necessary to reproduce the
results presented in a manuscript which is currently in preparation.  Note that
besides BEAST 2 itself, all XML files require the BEAST 2 package EpiInf to be
installed.  Installation instructions can be found on the project web page at
https://tgvaughan.github.io/EpiInf.

The files are as follows:

- validation_likelihood/

    * BD_DensityMap_r.xml:

        Simulates (1) an epidemic trajectory under the linear birth-death model
        with an explicit sampling process and (2) a sampled transmission tree compatible
        with this trajectory.  The XML then uses the algorithm presented in the
        paper to estimate the likelihood for various values of the
        removal-on-sampling parameter "r".  The likelihood values are also computed
        using an analytical solution.  Both sets of values are reported in the output.
        This script was used to produce the comparison shown in figure 2a of the
        manuscript.


    * SIS_DensityMap_beta.xml:

        Simulates (1) an epidemic trajectory under the nonlinear SIS model
        with an explicit sampling process and (2) a sampled transmission tree compatible
        with this trajectory.  The XML then uses the algorithm presented in the
        paper to estimate the likelihood for various values of the
        infection rate parameter "beta".  This script was used to produce the comparison
        shown in figure 2b of the manuscript.

- validation_incidence/

    * BD_traj_simulator.xml:

        Simulates an epidemic trajectory under the linear birth-death model
        with an explicit sampling model.  The simulated trajectory is saved in a
        file named "simulated.traj" in the current directory.

    * BD_inference.xml:

        When run using BEAST from the command line with the following arguments:
             beast -D leaf_frac=0.1 BD_inference.xml
        from a directory containing a simulated trajectory file named "simulated.traj",
        this script will generate samples from the posterior over the infection rate
        parameter "beta" with only 10% of the samples in the simulated trajectory
        corresponding to sampled phylogeny leaves, and the remaining corresponding
        to unsequenced samples.

        Running the same command but varying the value of leaf_frac will repeat the
        analysis with a varying fraction of samples assigned to tree leaves.

        Comparing the posterior distributions for "beta" from each such analysis
        will produce the results shown in figure 3 in the manuscript.

- simulated_inference/

    * BD_demo.xml:
        Simulates (1) an epidemic trajectory under the linear birth-death model
        with an explicit sampling process, (2) a sampled transmission tree compatible
        with this trajectory, and (3) a molecular sequence alignment by evolving a
        random ancestral sequence down this simulated tree.  The XML then uses
        the algorithm presented in the manuscript to jointly infer the sampled tree,
        epidemic trajectory and model parameters from the simulated sequence alignment.
        This script was used to produce the results shown in figure 4a.
        
    * SIS_demo.xml:

        Performs exactly the same sequence of operations as BD_demo.xml, but under
        the nonlinear SIS model.  This script was used to produce the results shown
        in figure 4b.
        
    * SIR_demo.xml:

        Performs exactly the same sequence of operations as BD_demo.xml, but under
        the nonlinear SIR model. This script was used to produce the results shown
        in figure 4c.

- validation_trajectory/

    * BD_psiSamp_inference.xml:

        Simulates (1) an epidemic trajectory under the linear birth-death model
        with an explicit sampling process, (2) a sampled transmission tree compatible
        with this trajectory, and (3) a molecular sequence alignment by evolving a
        random ancestral sequence down the simulated tree.  The XML then uses the
        algorithm presented in the manuscript to jointly infer the sampled tree
        and the epidemic trajectory, conditional on the true model parameters.

    * SIS_psiSamp_inference.xml:

        Performs exactly the same sequence of operations as BD_psiSamp_inference.xml,
        but under the nonlinear SIS model.

    * SIR_psiSamp_inference.xml:

        Performs exactly the same sequence of operations as BD_psiSamp_inference.xml,
        but under the nonlinear SIR model.

    * analyze_wc_results.R:

        Assuming that 200 of repetitions of the above analyses have been run with
        seeds 1 through 200 and that the output of these analyses has been placed
        in a subdirectory named "results/", this R script will summarise the trajectory
        inference results and save this summary to files named "resultsBD.txt",
        "resultsSIS.txt" and "resultsSIR.txt" in the current directory.

    * plot_wc_results.R:

        Assuming the results files generated by "analyze_wc_results.R" are in the
        current directory, this R script will produce the graphs shown as figure 5
        in the manuscript.

- ebola/

    * kailahun_seq+incidence.xml:

        Running this script will perform the Ebola virus analysis incorporating
        both genomic data and case count data whose results are presented in
        Figure 6 and Table 2 of the manuscript.

    * kailahun_seqonly_4weeks.xml:

        Running this script will perform the Ebola virus analysis incorporating
        only genomic data collected during the first 4 weeks of sampling as
        presented in Figure 6 of the manuscript.
