// Single source of truth for Generated Set 2 (16 questions, spanning the
// entire Midterm 1 syllabus: Lectures 2-9 plus Problem Set 3 topics).
//
// Difficulty/style deliberately calibrated against
// context/raw/discussion_practice/Discussion_Pset_3_Practice_Problems.pdf
// (concrete population models stated explicitly, heavy use of two-statement
// "(i)/(ii), which is correct" evaluation, numeric computation with built-in
// traps, and edge-case/transfer reasoning) rather than Set 1's more
// conceptual framing. All data-generating processes and numbers here are
// original -- none are reused from that document, from either old exam, or
// from any lecture worked example.
//
// Both generated_questions.typ and generated_solutions.typ render from
// this same array via generated_questions/typst_template.typ.

#let questions = (
  (
    prompt: [
      An online retailer fits OLS to model delivery cost as a function of
      shipping method, a categorical feature with three levels: Ground
      (the baseline category), Air, and Express. The model is
      `cost ~ 1 + shipping`, and R reports: intercept $= 12$,
      `shippingAir` $= 16$, `shippingExpress` $= 33$ (all in dollars).
      What does the coefficient on `shippingExpress` represent?
    ],
    choices: (
      [
        The difference between the mean delivery cost for Express
        shipments and the mean delivery cost for Ground (baseline)
        shipments.
      ],
      [The mean delivery cost for Express shipments, in dollars.],
      [
        The mean delivery cost for Express shipments minus the overall
        average delivery cost across all three shipping methods.
      ],
      [
        The change in delivery cost associated with a one-unit increase
        in "amount of express shipping."
      ],
    ),
    correct: 0,
    explanations: (
      [
        Correct. With one-hot encoding and Ground as baseline, each
        non-baseline coefficient is exactly the gap between that
        category's group mean and the baseline group's mean -- here,
        mean(Express) $-$ mean(Ground) $= 33$.
      ],
      [
        That would be intercept + coefficient ($12+33=45$), not the
        coefficient alone.
      ],
      [
        The baseline for a one-hot-encoded categorical feature is the
        *reference category* (Ground here), not the grand mean across all
        categories.
      ],
      [
        `shipping` is categorical, not continuous -- there's no
        "one-unit increase" in a dummy variable to speak of; this
        confuses a continuous-feature coefficient interpretation with a
        categorical one.
      ],
    ),
  ),
  (
    prompt: [
      You include two highly correlated (but not perfectly collinear)
      features -- years of experience and age -- in an OLS model
      predicting salary. Evaluate the following statements:

      (i) The model's predictions (and $R^2$) are reliable despite the
      high correlation between the two features.

      (ii) The individual coefficients on experience and age can each be
      interpreted as that feature's "pure," independent effect on salary,
      unaffected by the correlation between them.

      Which of the following is correct?
    ],
    choices: (
      [Only statement (i) is correct.],
      [Only statement (ii) is correct.],
      [Both statements are correct.],
      [Neither statement is correct.],
    ),
    correct: 0,
    note: [
      *(i) is correct.* As long as the two features aren't *exactly*
      collinear, $bold(X)^top bold(X)$ remains invertible and OLS
      still finds a well-defined, SSE-minimizing fitted value -- high
      correlation alone doesn't prevent OLS from fitting (and predicting)
      well.

      *(ii) is incorrect.* When two included features are highly
      correlated, OLS can't cleanly separate their individual
      contributions: the coefficients become unstable (small changes in
      the data can swing them substantially, even flip their sign), so
      they no longer have a clean "effect of this feature alone" reading.
      Collinearity threatens coefficient *interpretability*, not
      predictive accuracy.
    ],
    explanations: (
      [Correct -- see the reasoning above.],
      [(i) is also correct, so (ii) alone is not the full picture.],
      [(ii) is not correct, so both cannot be.],
      [(i) is correct, so it isn't true that neither is.],
    ),
  ),
  (
    prompt: [
      You evaluate several candidate models on a validation set and select
      the model with the lowest validation RMSE as the "winner." You then
      evaluate that winner on a separate test set that played no role in
      selecting the winner. Evaluate:

      (i) The winner's validation RMSE is an unbiased estimate of its
      true generalization error.

      (ii) The winner's test RMSE is an unbiased estimate of its true
      generalization error.

      Which of the following is correct?
    ],
    choices: (
      [Only statement (i) is correct.],
      [Only statement (ii) is correct.],
      [Both statements are correct.],
      [Neither statement is correct.],
    ),
    correct: 1,
    note: [
      *(ii) is correct, (i) is not.* The winner was specifically chosen
      *because* it had low validation error among the candidates -- that
      selection step means its validation RMSE is optimistic (a form of
      selection bias), so it systematically underestimates the winner's
      true generalization error. The test set played no role in choosing
      the winner, so the winner's test RMSE is an honest, unbiased
      estimate.
    ],
    explanations: (
      [(i) is not correct; see above.],
      [Correct -- see the reasoning above.],
      [(i) is not correct, so both cannot be.],
      [(ii) is correct, so it isn't true that neither is.],
    ),
  ),
  (
    prompt: [
      You fit a ridge regression using two features -- income (ranging
      from \$10,000 to \$500,000) and a 0/1 indicator for `has_degree` --
      without standardizing either feature first. What is the consequence
      of skipping standardization here?
    ],
    choices: (
      [
        Because the penalty $lambda sum_j hat(beta)_j^2$ is applied to
        the raw coefficient values, and income needs a tiny coefficient
        (since it's measured in large dollar units) while `has_degree`
        needs a much larger coefficient for comparable predictive impact,
        the penalty shrinks the two features' coefficients asymmetrically
        even if the features are equally predictive.
      ],
      [
        There's no real issue -- ridge regression is scale-invariant by
        construction, so standardization is purely a convenience, not a
        requirement.
      ],
      [
        Skipping standardization makes the fit biased even at $lambda=0$,
        since the unpenalized OLS solution itself depends on feature
        scale.
      ],
      [
        Skipping standardization only matters for lasso's sparsity
        property; ridge's shrinkage behavior is unaffected by feature
        scale.
      ],
    ),
    correct: 0,
    explanations: (
      [
        Correct. This is exactly why lecture states you should always
        standardize before fitting ridge or lasso: the penalty term
        treats raw coefficient magnitude as "large," but what counts as a
        large coefficient is purely an artifact of the feature's units.
      ],
      [
        Contradicts the lecture's explicit standardization requirement --
        ridge is *not* scale-invariant, precisely because the penalty
        term is scale-sensitive even though the SSE term alone isn't.
      ],
      [
        At $lambda=0$, ridge reduces exactly to OLS, and OLS's fitted
        values are scale-invariant (rescaling a feature just rescales its
        coefficient correspondingly) -- the problem is specific to the
        penalty term, not the base SSE objective.
      ],
      [
        The standardize-first principle applies to both ridge and lasso
        equally -- both penalties are scale-sensitive in the same way.
      ],
    ),
  ),
  (
    prompt: [
      From a dataset with 500 candidate features, you compute each
      feature's correlation with the outcome using the *entire* dataset,
      keep the 10 most correlated features, and then run 10-fold CV using
      only those 10 features to estimate the generalization error of the
      final model (which will be fit on all the data using those 10
      features). Is the resulting $"Err"_"CV"$ trustworthy?
    ],
    choices: (
      [
        No -- $"Err"_"CV"$ will typically *underestimate* the true
        generalization error, because the 10 features were chosen using
        information from every fold, including each fold when it is
        later held out, so the held-out folds aren't fully out-of-sample
        with respect to the feature-selection step.
      ],
      [
        No -- $"Err"_"CV"$ will typically *overestimate* the true
        generalization error, because using only 10 of 500 features makes
        the model simpler and therefore harder to fit well.
      ],
      [
        Yes, this is fine, because the outcome variable itself is never
        used inside any fold's model-*fitting* step -- only in the
        earlier screening step.
      ],
      [
        Yes, this is fine, as long as $K gt.eq 5$.
      ],
    ),
    correct: 0,
    explanations: (
      [
        Correct -- this is precisely the "cautionary hypothetical" from
        lecture: covariate selection is part of the learning algorithm,
        and it must be redone inside each fold (using only that fold's
        training data), or the held-out fold's information leaks into the
        model-selection step applied to it.
      ],
      [
        Backwards on both the direction and the mechanism -- the problem
        isn't model simplicity, it's that the feature-selection step saw
        data it shouldn't have.
      ],
      [
        This is exactly the tempting-but-wrong defense: the outcome
        *was* used, just one step earlier (to compute correlations for
        screening), and that's enough to leak held-out information into
        the folds that are supposed to be excluded from it.
      ],
      [
        The choice of $K$ has nothing to do with this problem -- the
        issue is leakage of information across the train/held-out
        boundary, which no choice of $K$ fixes.
      ],
    ),
  ),
  (
    prompt: [
      Compare $K=5$ vs. $K=n$ (leave-one-out) cross-validation for
      estimating the generalization error of a model that will ultimately
      be trained on the *entire* dataset. Evaluate:

      (i) Using $K=5$ instead of $K=n$ tends to *overestimate* the true
      generalization error of the final (full-data) model, since each
      fold's model is trained on less data than the final model will be.

      (ii) Using $K=n$ always gives a strictly more precise (lower
      variance) estimate of generalization error than $K=5$, simply
      because it uses more folds.

      Which of the following is correct?
    ],
    choices: (
      [Only statement (i) is correct.],
      [Only statement (ii) is correct.],
      [Both statements are correct.],
      [Neither statement is correct.],
    ),
    correct: 0,
    note: [
      *(i) is correct*: with $K=5$, each $hat(f)^(-k)$ trains on only
      $4/5$ of the data, so it tends to have higher error than a model
      trained on all of it -- inflating $"Err"_"CV"$ relative to the
      final model's true error.

      *(ii) is incorrect*: lecture explicitly flags the opposite risk at
      large $K$ -- with $K=n$, the $n$ fold-models differ from each other
      by only one observation each, so they're nearly identical, which
      makes $"Err"_"CV"$ highly *sensitive* to the specific dataset you
      happened to draw (i.e., high variance if you imagine repeating the
      whole procedure on a fresh dataset). "More folds" doesn't
      automatically mean "more precise."
    ],
    explanations: (
      [Correct -- see the reasoning above.],
      [(ii) is not correct; see above.],
      [(ii) is not correct, so both cannot be.],
      [(i) is correct, so it isn't true that neither is.],
    ),
  ),
  (
    prompt: [
      A screening test is applied to $n=2000$ patients. Of the 40 patients
      who actually have the condition, the test flags 30 correctly (and
      misses 10). Of the 1960 patients who don't have the condition, the
      test incorrectly flags 40 as positive. What is the *false discovery
      proportion* (FDP) of this test -- the fraction of its positive
      predictions that are actually wrong?
    ],
    choices: (
      [$40/70 approx 0.57$],
      [$10/40 = 0.25$],
      [$40/1960 approx 0.02$],
      [$40/2000 = 0.02$],
    ),
    correct: 0,
    note: [
      $"FP"=40$ (table says so directly); $"TP" = 40-10=30$; total
      predicted positive $= "TP"+"FP" = 30+40=70$. FDP
      $="FP"/("TP"+"FP") = 40/70 approx 0.57$.
    ],
    explanations: (
      [Correct, by the computation above.],
      [
        This is $"FN"/("FN"+"TP") = 10/40$, the false negative rate --
        a rate among actual positives, not among positive predictions.
      ],
      [
        This is $"FP"/("TN"+"FP") = 40/1960$, the false positive rate --
        a rate among actual negatives, not among positive predictions.
      ],
      [
        This divides by the total sample size instead of by the number
        of positive predictions, which isn't any of the standard
        confusion-matrix metrics.
      ],
    ),
  ),
  (
    prompt: [
      Classifier A has AUC $=0.80$; Classifier B has AUC $=0.75$, but
      their ROC curves cross: B's curve lies *above* A's for false
      positive rates below 0.1, and below A's curve everywhere else. A
      hospital screening for a dangerous condition is only willing to
      tolerate a false positive rate of at most 5% (i.e., it will operate
      strictly within that crossing region). Which classifier should it
      prefer, and why?
    ],
    choices: (
      [
        Classifier B -- at the hospital's actual operating point (FPR
        $lt.eq 5%$, inside the region where B's curve lies above A's), B
        achieves a higher true positive rate there, even though A has the
        higher *overall* AUC. AUC summarizes performance averaged across
        all thresholds, not specifically at the one operating point that
        matters here.
      ],
      [
        Classifier A, because it has the higher AUC, and AUC is always
        the right criterion for choosing between classifiers regardless
        of context.
      ],
      [
        It doesn't matter which one they choose, since both classifiers
        achieve the same accuracy at any fixed threshold.
      ],
      [
        Classifier A, because a crossing ROC curve means Classifier B's
        results are unreliable.
      ],
    ),
    correct: 0,
    explanations: (
      [
        Correct -- a higher-AUC classifier need not give the better
        tradeoff at the *specific* threshold a decision-maker actually
        cares about; that's exactly why ROC curves (not just the single
        AUC number) matter for decision-making.
      ],
      [
        This is the mistake the question is testing: AUC is a convenient
        single-number summary, but it compresses away exactly the
        threshold-specific information a real decision-maker needs.
      ],
      [
        False -- the two classifiers have different TPRs at a fixed FPR
        (that's what "the curves cross" means); their accuracies at any
        given threshold generally differ.
      ],
      [
        Crossing ROC curves are a completely ordinary occurrence between
        two reasonable classifiers -- it doesn't imply either one is
        unreliable.
      ],
    ),
  ),
  (
    prompt: [
      Which of the following is *not* one of the three steps in the
      general maximum likelihood estimation (MLE) recipe presented in
      lecture?
    ],
    choices: (
      [Assume a distributional form for how the data was generated.],
      [
        Compute (write down) the likelihood of the observed data under
        that assumed distribution.
      ],
      [Choose the parameter values that maximize that likelihood.],
      [
        Split the data into training and validation sets to prevent
        overfitting.
      ],
    ),
    correct: 3,
    explanations: (
      [This is Step 1 of the MLE recipe.],
      [This is Step 2 of the MLE recipe.],
      [This is Step 3 of the MLE recipe.],
      [
        Correct -- this is model *selection/evaluation* methodology
        (train-validate-test), a separate concern from how MLE fits one
        given model to data. MLE is a fitting procedure; splitting data
        is how you'd later choose among different fitted models or
        estimate generalization error. Conflating the two is a common
        mistake.
      ],
    ),
  ),
  (
    prompt: [
      Which of the following is correct?
    ],
    choices: (
      [
        Logistic regression's negative log-likelihood (log loss) is
        convex in the coefficients, so any local minimum found by an
        iterative optimizer is guaranteed to be the global minimum; this
        guarantee does *not* carry over to neural networks, whose loss
        surfaces are generally non-convex.
      ],
      [
        Both logistic regression and neural network training are convex
        optimization problems, since both minimize a loss function using
        gradient-based methods.
      ],
      [
        Logistic regression's loss is non-convex, which is exactly why
        iteratively reweighted least squares is needed instead of plain
        gradient descent.
      ],
      [
        Convexity is a property of the dataset, not the loss function, so
        whether logistic regression's optimization is convex depends on
        whether the data happens to be linearly separable.
      ],
    ),
    correct: 0,
    explanations: (
      [
        Correct -- this convex vs. non-convex distinction is exactly why
        logistic regression always finds the (unique) MLE reliably, while
        neural network training has no such guarantee and can get stuck
        in different local minima depending on initialization.
      ],
      [
        Using gradient-based methods doesn't make a problem convex --
        gradient descent is applied to both convex and non-convex
        problems; it's a property of the loss surface's shape, not of the
        optimizer.
      ],
      [
        Backwards -- logistic regression's log loss *is* convex; IRLS is
        simply one efficient algorithm for solving that particular convex
        problem, not a workaround for non-convexity.
      ],
      [
        Convexity here is a property of the *log-loss function* as a
        function of the coefficients, which holds regardless of whether
        the data is linearly separable (though a finite MLE may fail to
        exist in the perfectly-separable case, convexity itself doesn't
        depend on it).
      ],
    ),
  ),
  (
    prompt: [
      You fit ridge regression on *standardized* features, so that as
      $lambda -> infinity$, every feature coefficient is driven to exactly
      zero and the model's prediction converges to just the intercept
      (which, for standardized features, equals $overline(Y)$). Assuming
      the true population model is *not* simply a constant, what happens
      to the model's bias and variance as $lambda -> infinity$?
    ],
    choices: (
      [
        Both converge to the bias and variance of the constant-mean
        predictor $overline(Y)$: variance shrinks to the (generally
        small but nonzero) variance of the sample mean, while bias
        converges to a fixed, generally *nonzero* value -- the gap
        between the true conditional mean and the unconditional
        population mean. Ridge trades away its features' predictive
        content for stability, landing at a high-bias, low-variance
        extreme.
      ],
      [
        Both bias and variance converge to zero, since $lambda ->
        infinity$ makes the model maximally regularized and therefore
        maximally accurate.
      ],
      [
        Variance converges to zero (the model no longer depends on any
        feature), but bias stays exactly zero throughout, just as it was
        for OLS under (A1)--(A3), since ridge never introduces bias.
      ],
      [
        Both bias and variance increase without bound as $lambda ->
        infinity$, since an infinitely large penalty destabilizes the
        fitting procedure.
      ],
    ),
    correct: 0,
    explanations: (
      [
        Correct -- in the limit, ridge is no longer "ridge regression on
        features," it's just "predict the sample mean," which is exactly
        the constant-prediction case from the bias-variance decomposition
        (zero variance in the population-model sense, generally nonzero
        bias unless the truth happens to be constant).
      ],
      [
        Maximal regularization does not mean maximal accuracy -- it means
        maximal *simplicity*, which trades variance for bias; pushed to
        the extreme, you simply discard all the features' information.
      ],
      [
        Ridge's zero-bias property under (A1)--(A3) belongs to OLS
        ($lambda=0$) specifically; once $lambda>0$ shrinks coefficients
        away from the unbiased OLS solution, bias is generally
        reintroduced -- exactly the Gauss-Markov tradeoff, taken to its
        limit.
      ],
      [
        Backwards -- variance *shrinks* (not grows) as $lambda ->
        infinity$, since the fitted model becomes *less* sensitive to
        which particular training sample was drawn, not more.
      ],
    ),
  ),
  (
    prompt: [
      Suppose the population model is $Y = 4X + epsilon$, where $X > 0$,
      $EE[epsilon | X] = 0$, and $"Var"(epsilon | X) = 16/X^2$ (the
      error variance *shrinks* as $X$ grows). You have a sample in which
      $X$ takes many different values, and you estimate the coefficient
      on $X$ (no intercept) two ways: by OLS, and by WLS with weights
      $w_i = X_i^2$. Evaluate:

      (i) The OLS estimate of the coefficient is unbiased.

      (ii) The WLS estimate of the coefficient has lower variance than
      the OLS estimate.

      Which of the following is correct?
    ],
    choices: (
      [Only statement (i) is correct.],
      [Only statement (ii) is correct.],
      [Both statements (i) and (ii) are correct.],
      [Neither statement (i) nor (ii) is correct.],
    ),
    correct: 2,
    note: [
      *Both are correct.* Bias depends only on whether errors average to
      zero at each $X$ ($EE[epsilon | X]=0$ here, for both methods), not
      on how the error variance behaves -- heteroskedasticity changes how
      *noisy* observations are, not where they're centered, so both OLS
      and WLS are unbiased. Weights $w_i = X_i^2 = 1 / "Var"(epsilon_i mid
      X_i)$ are exactly the inverse-variance weights here, which is
      precisely the choice that gives WLS the minimum possible variance
      among linear unbiased estimators under heteroskedastic errors
      (the generalization of Gauss-Markov to the WLS/heteroskedastic
      setting) -- so WLS has lower variance than unweighted OLS.
    ],
    explanations: (
      [(ii) is also correct, so (i) alone is not the full picture.],
      [(i) is also correct, so (ii) alone is not the full picture.],
      [Correct -- see the reasoning above.],
      [Both (i) and (ii) are correct, so it isn't true that neither is.],
    ),
  ),
  (
    prompt: [
      Suppose the population model is $Y = 10 + 0.5X + X epsilon$, where
      $X > 0$ and $epsilon$ is normally distributed with mean zero and
      variance $4$, independent of $X$ (so the spread of $Y$ around
      $10+0.5X$ grows with $X$). Consider the population conditional
      quantiles of $Y$ given $X$ -- the true lines that quantile
      regression with $tau=0.2$ and $tau=0.7$ are trying to estimate.
      Which of the following is correct?
    ],
    choices: (
      [The $tau=0.2$ and $tau=0.7$ lines are parallel.],
      [The $tau=0.2$ line has a larger slope than the $tau=0.7$ line.],
      [The $tau=0.7$ line has a larger slope than the $tau=0.2$ line.],
      [Both lines are the same as the conditional mean line $10+0.5X$.],
    ),
    correct: 2,
    note: [
      The $tau$-quantile of $Y$ given $X$ is
      $10 + 0.5X + z_tau dot 2X = 10 + (0.5+2z_tau)X$, where $z_tau$ is
      the $tau$-quantile of a standard normal. Since $z_0.7 > 0 > z_0.2$,
      the $tau=0.7$ line has the larger slope -- the lines fan out as $X$
      grows, exactly tracking how the spread of $Y$ around its mean grows
      with $X$.
    ],
    explanations: (
      [
        Wrong -- parallel lines would mean the spread of $Y$ around the
        mean is the same at every $X$, which contradicts the stated
        model (spread grows with $X$).
      ],
      [
        Backwards -- $z_0.2 < 0$, so the $tau=0.2$ line's slope
        ($0.5+2z_0.2$) is *smaller* than $0.5$, not larger than the
        $tau=0.7$ line's.
      ],
      [Correct -- see the computation above.],
      [
        Only the conditional *mean* line is $10+0.5X$ -- the quantile
        lines (for $tau eq.not 0.5$) deviate from it by an amount that
        grows with $X$, precisely because the noise term is multiplied
        by $X$.
      ],
    ),
  ),
  (
    prompt: [
      When using $k$-nearest-neighbors imputation to fill in missing
      feature values, which of the following correctly describes the
      tradeoff in choosing $k$?
    ],
    choices: (
      [
        Small $k$ makes the imputed value highly sensitive to the noise
        in just a few nearby observations (high variance); large $k$
        averages over less locally-relevant observations, smoothing out
        genuine local structure (introducing bias) -- directly analogous
        to the bias-variance tradeoff in using $k$-NN for prediction.
      ],
      [
        Small $k$ always introduces more bias, since it ignores most of
        the dataset; large $k$ always has the lowest variance, since it
        uses the most available data.
      ],
      [
        The choice of $k$ for imputation has no connection to the
        bias-variance tradeoff discussed for prediction, since imputation
        is a preprocessing step, not a predictive model.
      ],
      [
        Larger $k$ is always preferable for imputation, since it uses
        more information and is therefore less likely to be wrong on any
        single missing value.
      ],
    ),
    correct: 0,
    explanations: (
      [
        Correct -- this is a direct analogue of the usual bias-variance
        tradeoff in choosing $k$ for $k$-NN prediction generally: fewer
        neighbors means more noise-sensitivity, more neighbors means more
        smoothing/potential bias.
      ],
      [
        Reverses which extreme causes which problem -- it's *small* $k$
        that causes high variance (noise-sensitivity), and *large* $k$
        that risks bias (over-smoothing), not the other way around.
      ],
      [
        Imputation via $k$-NN averaging is itself a form of local
        prediction (predicting the missing value from nearby
        observations), so the same bias-variance logic applies directly.
      ],
      [
        Ignores the oversmoothing cost of large $k$ -- averaging over
        increasingly dissimilar observations can wash out the genuine
        local relationship, which is exactly the bias side of the
        tradeoff.
      ],
    ),
  ),
  (
    prompt: [
      You fit regression trees on the same training set using the same
      deterministic tree-building procedure, with no complexity penalty,
      varying only the maximum depth, and use 5-fold cross-validation to
      estimate generalization error at each depth. Evaluate:

      (i) Shallow trees (small maximum depth) tend to have higher bias
      than deeper trees.

      (ii) Cross-validation RMSE is minimized at the deepest tree
      considered, since deeper trees always fit the training data at
      least as well.

      Which of the following is correct?
    ],
    choices: (
      [Only statement (i) is correct.],
      [Only statement (ii) is correct.],
      [Both statements are correct.],
      [Neither statement is correct.],
    ),
    correct: 0,
    note: [
      *(i) is correct*: a shallow tree can only partition the data into a
      few coarse groups, so it can't capture finer structure in the true
      relationship -- it underfits, i.e. has higher bias.

      *(ii) is incorrect*: it's *training* error that is non-increasing in
      depth (deeper trees can only fit the training data at least as
      well), but that's a different claim from CV error. Deeper trees
      become increasingly sensitive to the specific training sample
      (higher variance), so CV error typically falls and then *rises*
      again at large depth -- it is generally minimized at some
      intermediate depth, not the deepest one considered.
    ],
    explanations: (
      [Correct -- see the reasoning above.],
      [(ii) is not correct; see above.],
      [(ii) is not correct, so both cannot be.],
      [(i) is correct, so it isn't true that neither is.],
    ),
  ),
  (
    prompt: [
      Let $hat(p)$ be the fraction of "successes" in a sample of $n$
      i.i.d. $"Bernoulli"(p)$ trials (e.g., the fraction of surveyed
      voters who support a candidate), used as an estimator of the true
      population proportion $p$. Using the estimator bias-variance
      framework ($"MSE" = "Bias"^2 + "Variance"$, no irreducible-error
      term), which of the following is correct about $hat(p)$ as an
      estimator of $p$?
    ],
    choices: (
      [
        $hat(p)$ is unbiased for $p$ ($EE[hat(p)]=p$), and its variance
        is $p(1-p)/n$, which shrinks as $n$ grows -- so
        $"MSE" = 0 + p(1-p)/n -> 0$ as $n -> infinity$.
      ],
      [
        $hat(p)$ is unbiased, but since estimating a proportion involves
        averaging random (0/1) outcomes, $"MSE"$ must also include an
        irreducible error term reflecting the randomness of each
        individual trial.
      ],
      [
        $hat(p)$ is biased toward $0.5$, since averaging binary outcomes
        pulls the estimate toward the middle of its possible range.
      ],
      [
        The variance of $hat(p)$ is $p(1-p)$ and does not depend on $n$,
        since variance is a population quantity, not a sample quantity.
      ],
    ),
    correct: 0,
    explanations: (
      [
        Correct. $hat(p)$ is a sample mean of i.i.d. $"Bernoulli"(p)$
        draws, so $EE[hat(p)]=p$ (unbiased) and
        $"Var"(hat(p)) = p(1-p)/n$ (population variance of one
        Bernoulli draw, divided by $n$, exactly like any sample mean).
      ],
      [
        This is the Lecture 7 vs. Lecture 8 confusion again: irreducible
        error belongs to *predicting a new random outcome* $Y$, not to
        *estimating a fixed population parameter* $p$. Here the target
        is $p$ itself (fixed under the frequentist view), so there's no
        irreducible-error term, no matter how "random" the individual
        trials feel.
      ],
      [
        $hat(p)$ is an unbiased average of the data -- it's centered
        exactly at the true $p$, wherever $p$ happens to be, not pulled
        toward $0.5$.
      ],
      [
        Confuses the variance of a *single* Bernoulli draw
        ($"Var"(Y_i)=p(1-p)$, which indeed doesn't depend on $n$) with the
        variance of the *estimator* $hat(p)$ (the average of $n$ such
        draws), which does shrink with $n$ like any sample mean's
        variance.
      ],
    ),
  ),
)
