// Single source of truth for Generated Set 1 (10 questions, weighted
// toward Lectures 7-9: bias-variance decomposition, frequentist
// inference, standard errors & confidence intervals for the sample mean).
//
// Both generated_questions.typ and generated_solutions.typ render from
// this same array via context/src/typst_template.typ, so the two files
// can never drift out of sync with each other.

#let questions = (
  (
    prompt: [
      A learning algorithm predicts an outcome at a fixed covariate vector
      $arrow(X)$. At this point, the irreducible error is
      $sigma^2 (arrow(X)) = 9$, the bias is $-2$, and the variance is $5$.
      What is the resulting Average MSE?
    ],
    choices: ([$18$], [$12$], [$9$], [$sqrt(18) approx 4.24$]),
    correct: 0,
    note: [
      Average MSE = irreducible error + $"Bias"^2$ + Variance
      $= 9 + (-2)^2 + 5 = 9 + 4 + 5 = 18$.
    ],
    explanations: (
      [Correct --- the arithmetic above.],
      [
        Uses Bias instead of $"Bias"^2$: $9 + (-2) + 5 = 12$. The
        decomposition requires squaring the bias; a negative bias still
        costs you positive MSE.
      ],
      [
        Drops the irreducible error term entirely ($(-2)^2 + 5 = 9$) ---
        this is the *estimator* MSE formula from Lecture 8
        ($"MSE" = "Bias"^2 + "Variance"$, no irreducible error), not the
        *prediction* MSE formula from Lecture 7. Mixing up the two
        decompositions is the single easiest way to get this kind of
        question wrong.
      ],
      [Confuses MSE with RMSE by taking a square root that doesn't belong here.],
    ),
  ),
  (
    prompt: [
      A fellow student claims: "There's always a strict bias-variance
      tradeoff: whenever you change your learning algorithm so that
      variance decreases, bias must increase, and vice versa." Which of
      the following best evaluates this claim, based on what was covered
      in lecture?
    ],
    choices: (
      [
        Correct --- this follows directly from the bias-variance
        decomposition, since Average MSE = irreducible error +
        $"Bias"^2$ + Variance, and the three terms must always sum to a
        fixed total.
      ],
      [
        Correct --- the Gauss-Markov theorem shows OLS has the lowest
        variance among all zero-bias estimators using a given feature
        set, so no learning algorithm can ever have both lower bias and
        lower variance than another.
      ],
      [
        Incorrect --- the decomposition is just that, a decomposition,
        not a conservation law. Nothing forces bias and variance to move
        in opposite directions, and lecture gave explicit examples
        (double descent; adding genuinely informative features) where
        both bias and variance decreased at the same time.
      ],
      [
        Incorrect --- in fact the opposite is true: bias and variance
        always move together in the *same* direction as model
        complexity increases.
      ],
    ),
    correct: 2,
    explanations: (
      [
        Misreads "decomposition" as "fixed total." Nothing constrains
        Average MSE to stay constant --- a learning algorithm can simply
        get better (lower MSE) by improving bias and variance
        simultaneously.
      ],
      [
        The Gauss-Markov theorem is real, but it only applies to a
        specific comparison: linear, *unbiased* estimators using a
        *fixed* feature set. It says nothing about comparisons across
        different feature sets or non-linear algorithms, which is
        exactly the loophole double descent and the weight-measurement
        example exploit.
      ],
      [
        Correct. The bias-variance decomposition, Average MSE =
        irreducible error + $"Bias"^2$ + Variance, is exactly that --- a
        decomposition of whatever MSE happens to be, not a conservation
        law that forces the pieces to trade off. Lecture gave concrete
        counterexamples: the repeated weight-measurement example (both
        bias and variance fell as more measurements were added) and the
        double-descent lasso example (adding genuinely informative
        features reduced both bias and variance, and even reduced the
        "irreducible" error relative to the enlarged feature set).
      ],
      [
        Overcorrects to the opposite blanket claim. Bias and variance
        don't always move together either (e.g., regularization's whole
        point is moving them in opposite directions) --- there's simply
        no universal law either way.
      ],
    ),
  ),
  (
    prompt: [
      Assume (A1)--(A3) hold (linear population model; all relevant
      features observed; homoskedastic, mean-zero errors). A data
      scientist fits a ridge regression model with $lambda > 0$ on the
      same features used by an OLS model, and finds the ridge model has
      strictly lower variance than OLS at every test point. What must be
      true of the ridge model's bias, and why?
    ],
    choices: (
      [
        It must be exactly zero too, since ridge regression --- like
        OLS --- is a linear, unbiased estimator under (A1)--(A3).
      ],
      [
        It must be nonzero (strictly positive, in the sense of having
        nonzero bias at some point), because the Gauss-Markov theorem
        says OLS has the lowest variance among *all* linear, unbiased
        estimators using these features --- so a linear estimator with
        strictly lower variance than OLS cannot also be unbiased.
      ],
      [
        It could be anything --- positive, negative, or zero --- since
        bias and variance are unrelated quantities under (A1)--(A3).
      ],
      [
        It must be *lower* than OLS's bias (i.e., closer to zero), since
        regularization is specifically designed to correct bias in the
        OLS estimate.
      ],
    ),
    correct: 1,
    explanations: (
      [
        Contradicts the Gauss-Markov theorem directly: no unbiased
        linear estimator can beat OLS's variance.
      ],
      [
        Correct. Under (A1)--(A3), the Gauss-Markov theorem says OLS has
        the *lowest variance among all linear, unbiased estimators* that
        use the same features. If the ridge estimator (which is linear
        in $bold(Y)$) has strictly lower variance than OLS, it cannot be
        unbiased --- otherwise it would contradict OLS's optimality
        within that class. So the ridge model must have nonzero bias
        somewhere.
      ],
      [
        Ignores Gauss-Markov. This is the right instinct when comparing
        across *different feature sets* or *different algorithm
        families* (Question 2's lesson), but Gauss-Markov gives a
        precise, forced relationship for *this specific* comparison
        (ridge vs. OLS, same features, under A1--A3) --- context
        matters.
      ],
      [
        Backwards. Regularization's mechanism is to *add* bias in
        exchange for variance reduction, not to "correct" an existing
        OLS bias (OLS already has zero bias under A1--A3, so there's no
        bias to correct).
      ],
    ),
  ),
  (
    prompt: [
      Assume (A1)--(A3) hold for a population model with three relevant
      features $A$, $B$, $C$: $Y = beta_A A + beta_B B + beta_C C +
      epsilon$. A data scientist fits OLS using only $A$ and $B$,
      omitting $C$. Which of the following is the most accurate
      statement about the resulting model?
    ],
    choices: (
      [
        The model is unbiased --- OLS remains BLUE (Best Linear Unbiased
        Estimator) even when a relevant feature is omitted, as long as
        the remaining features are observed correctly.
      ],
      [
        The model is generally biased, and the size of that bias does
        not depend at all on how $C$ is correlated with $A$ and $B$ ---
        omitting any relevant feature produces the same bias regardless
        of correlation structure.
      ],
      [
        The model is generally biased, and the size of the bias ---
        along with any distortion to the fitted coefficients on $A$ and
        $B$ themselves --- depends on how correlated the omitted feature
        $C$ is with $A$ and $B$.
      ],
      [
        The model is biased, but only in its predictions --- the fitted
        coefficients on $A$ and $B$ remain correct (unbiased) estimates
        of $beta_A$ and $beta_B$.
      ],
    ),
    correct: 2,
    explanations: (
      [
        Gauss-Markov's zero-bias guarantee requires (A2) --- *all*
        relevant features observed. Omitting $C$ violates this, so the
        guarantee simply doesn't apply here.
      ],
      [
        Directly contradicts the lecture's point that the bias "depends
        on how correlated the remaining features are with the omitted
        features."
      ],
      [
        Correct, per the lecture's remarks on omitted-variable bias
        (OVB): omitting a relevant feature breaks assumption (A2) (not
        all relevant features observed), so the Gauss-Markov zero-bias
        guarantee no longer applies, and both the size of the resulting
        bias and the distortion to the fitted coefficients on the
        *included* features depend on the correlation between the
        omitted and included features.
      ],
      [
        Contradicts the omitted-variable-bias (OVB) phenomenon
        explicitly named in lecture: omitting a correlated feature can
        corrupt the *coefficients* on the included features too, not
        just the final predictions.
      ],
    ),
  ),
  (
    prompt: [
      In Lecture 7, the bias-variance decomposition for a prediction
      $hat(f)(arrow(X))$ includes an irreducible error term
      $sigma^2 (arrow(X))$. In Lecture 8, the analogous decomposition for an
      estimator $hat(theta)$ of a population parameter $theta$ is simply
      $"MSE" = "Bias"^2 + "Variance"$, with *no* irreducible error term.
      Why does the estimator decomposition have no irreducible error
      term?
    ],
    choices: (
      [
        Because estimators are always unbiased, so there is nothing left
        to attribute to irreducible error.
      ],
      [
        Because the irreducible error term only matters for
        classification problems, not for estimating a continuous
        parameter.
      ],
      [
        Because the true outcome $Y$ being predicted in the prediction
        problem is itself random even conditional on $arrow(X)$, whereas
        the parameter $theta$ being estimated is treated as a *fixed*
        (non-random) quantity under the frequentist view --- so there's
        no analogous "irreducible" randomness in the target itself.
      ],
      [
        Because irreducible error only arises when the sample size is
        small; for the large-$n$ asymptotic theory used in estimation,
        it vanishes.
      ],
    ),
    correct: 2,
    explanations: (
      [
        False in general --- plenty of estimators are biased (e.g., OLS
        with an omitted feature, from Question 4). Being unbiased isn't
        why the irreducible-error term disappears; the reason is about
        what kind of thing the *target* is (random outcome vs. fixed
        parameter), not about the estimator's own bias.
      ],
      [
        Invents a restriction that isn't in the material --- irreducible
        error is a general prediction-theory concept, not
        classification-specific.
      ],
      [
        Correct. Irreducible error in the prediction setting exists
        because the *target* $Y$ is itself a random variable with
        leftover variance even given $arrow(X)$ exactly (i.e.,
        $sigma^2 (arrow(X)) = "Var"(Y | arrow(X)) > 0$ in general). In the
        estimation setting, the target is a population parameter
        $theta$, which the frequentist view treats as a *fixed*,
        non-random quantity --- there's no analogous leftover randomness
        in a fixed number, so there's nothing for an "irreducible error"
        term to capture.
      ],
      [
        Confuses two different "shrinks with $n$" facts: it's the
        *variance* of an estimator that shrinks as $n$ grows, not
        irreducible error (which, in the prediction setting, is about
        the conditional variance of $Y$ given $arrow(X)$ and has nothing
        to do with how much data you have).
      ],
    ),
  ),
  (
    prompt: [
      Under the frequentist view of statistical inference, which of the
      following is randomly varying across "parallel universes," and
      which is fixed?
    ],
    choices: (
      [The population parameter $theta$ is random; the data sample is fixed.],
      [Both the population parameter $theta$ and the data sample are random.],
      [
        The population parameter $theta$ is fixed; the data sample (and
        therefore any estimator computed from it) is random.
      ],
      [
        Both the population parameter $theta$ and the data sample are
        fixed once the sample has been collected --- there is no
        remaining randomness to reason about.
      ],
    ),
    correct: 2,
    explanations: (
      [
        Reverses the frequentist view (closer to how some people
        informally imagine a Bayesian perspective, but even that isn't
        quite this).
      ],
      [
        Treats the parameter as random too, which the frequentist view
        explicitly rejects.
      ],
      [
        Correct --- this is the core frequentist premise: the true
        parameter $theta$ is fixed and unknown; the only randomness is in
        which particular data sample you happened to draw (the "parallel
        universes" thought experiment), and any estimator computed from
        that sample inherits its randomness.
      ],
      [
        A common but mistaken intuition: once you're holding a specific,
        already-collected dataset, the *numbers in front of you* are
        fixed, but that doesn't mean there was no randomness in the
        process that produced them. The parallel-universes framework
        reasons about the data-generating process, not about a single
        realized dataset in isolation.
      ],
    ),
  ),
  (
    prompt: [
      You estimate a population mean $mu$ using the sample mean of $n$
      i.i.d. draws. With a sample of size $n=25$ you compute standard
      error $hat("SE")_25$; with a much larger sample of size $n = 400$
      (and roughly the same sample standard deviation $hat(sigma)$) you
      compute $hat("SE")_400$. Approximately how do these compare?
    ],
    choices: (
      [$hat("SE")_25$ is about $4$ times larger than $hat("SE")_400$.],
      [$hat("SE")_25$ is about $16$ times larger than $hat("SE")_400$.],
      [
        $hat("SE")_25$ and $hat("SE")_400$ are approximately equal, since
        standard error doesn't depend on sample size once $hat(sigma)$ is
        fixed.
      ],
      [$hat("SE")_400$ is about $4$ times larger than $hat("SE")_25$.],
    ),
    correct: 0,
    note: [
      $"SE" = hat(sigma)/sqrt(n)$, so the ratio of standard errors is the
      *inverse square root* of the ratio of sample sizes:
      $ hat("SE")_25 / hat("SE")_400 = sqrt(400)/sqrt(25) = 20/5 = 4. $
      So $hat("SE")_25$ is about 4 times larger than $hat("SE")_400$.
    ],
    explanations: (
      [Correct, by the computation above.],
      [
        Uses the ratio of sample sizes directly ($400/25=16$) instead of
        the ratio of their square roots --- forgetting that SE scales
        with $1/sqrt(n)$, not $1/n$.
      ],
      [
        Confuses the standard deviation of individual observations
        (which doesn't shrink with $n$) with the standard error of the
        sample *mean* (which does, proportionally to $1/sqrt(n)$) ---
        precisely the distinction lecture called out as important to
        keep straight.
      ],
      [
        Gets the direction backwards: *more* data means a *smaller*
        standard error, not a larger one, so it's $hat("SE")_25$ that's
        bigger.
      ],
    ),
  ),
  (
    prompt: [
      After collecting a sample and computing a 95% confidence interval
      $[28.1, 35.7]$ for a population mean $mu$, a colleague says: "There
      is a 95% probability that $mu$ is between 28.1 and 35.7." Is this an
      accurate interpretation, as discussed in lecture?
    ],
    choices: (
      [
        Yes --- by definition, a 95% confidence interval means there's a
        95% probability the true parameter falls inside this specific
        interval.
      ],
      [
        No --- the 95% figure describes the *procedure*: across repeated
        samples, 95% of the resulting intervals would contain the true,
        fixed $mu$. Once a specific interval like $[28.1, 35.7]$ has been
        computed, $mu$ either is or isn't in it; $mu$ is not a random
        variable, so it doesn't make sense to assign it a probability.
      ],
      [
        No --- the correct statement is that there's a 95% probability
        the *sample mean* $overline(Y)$ falls between 28.1 and 35.7.
      ],
      [
        Yes, but only if the underlying population distribution is
        itself normal; otherwise the 95% figure doesn't apply.
      ],
    ),
    correct: 1,
    explanations: (
      [
        This is exactly the tempting-but-incorrect interpretation
        flagged in lecture: it treats $mu$ as if it were still random
        after the interval has been computed.
      ],
      [
        Correct. A confidence interval's coverage is a statement about
        the *procedure*, evaluated across repeated samples (parallel
        universes): 95% of the intervals this procedure produces will
        contain the true $mu$. Once you've plugged in one actual sample
        and computed one specific interval, there's no more randomness
        left in $mu$ to assign a probability to --- $mu$ is fixed; the
        interval (built from your random sample) was the random object,
        before you computed it.
      ],
      [
        Misapplies the 95% figure to $overline(Y)$ instead of $mu$ ---
        and doesn't even make sense on its own terms, since a symmetric
        CI is centered exactly on the observed $overline(Y)$, which
        trivially lies at the interval's midpoint, not in it "with 95%
        probability."
      ],
      [
        Not required: the Central Limit Theorem guarantees the sampling
        distribution of $overline(Y)$ is approximately normal for large
        $n$ *regardless of the shape of the individual $Y_i$'s
        distribution* --- that was explicitly called out in lecture as
        the "remarkable" part of the CLT.
      ],
    ),
  ),
  (
    prompt: [
      Holding the sample size $n$ and sample standard deviation
      $hat(sigma)$ fixed, consider two confidence intervals for the
      population mean constructed from the same sample: a 95% CI and a
      99% CI. Evaluate:

      (i) The 99% CI is wider than the 95% CI.

      (ii) The 99% CI is guaranteed to contain the true population mean
      $mu$, while the 95% CI is not.

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
      *(i) is correct.* A higher confidence level requires a larger
      critical value ($z_(alpha\/2) approx 2.58$ for 99% vs. $1.96$ for
      95%), which directly widens the interval
      $overline(Y) plus.minus z_(alpha\/2) hat("SE")$, holding $n$ and
      $hat(sigma)$ (and hence $hat("SE")$) fixed.

      *(ii) is incorrect.* "Guaranteed to contain $mu$" describes neither
      interval. Both are built from the same random sample and both have
      only a long-run *coverage rate* (99% or 95%, respectively, across
      repeated sampling) --- not a guarantee for this one specific
      interval. This is the same misconception as Question 8, applied to
      a comparison between two intervals instead of one.

      Since (i) is correct and (ii) is not, the answer is (a).
    ],
    explanations: (
      [Correct --- see the reasoning above.],
      [(ii) alone is not correct; see above.],
      [(ii) is not correct, so both cannot be.],
      [(i) is correct, so it isn't true that neither is.],
    ),
  ),
  (
    prompt: [
      Consider the sample mean $overline(Y)$ computed from $n$ i.i.d.
      draws from a population with mean $mu$ and variance $sigma^2$. The
      same quantity $overline(Y)$ can be analyzed two ways covered in
      this course: (I) as a *prediction* of a new, as-yet-unseen outcome
      $Y$ from the same population, and (II) as an *estimator* of the
      population parameter $mu$ itself. Which of the following correctly
      compares the Bias and Variance terms, and the overall MSE, across
      these two analyses?
    ],
    choices: (
      [
        Bias and Variance are different in the two analyses, because
        predicting $Y$ requires a different formula for $overline(Y)$
        than estimating $mu$.
      ],
      [
        Bias and Variance are identical in the two analyses --- in both
        cases Bias $=0$ and Variance $=sigma^2/n$ --- but the overall MSE
        differs, because the prediction-MSE additionally includes the
        irreducible error term $sigma^2$, which has no counterpart when
        the target is the fixed parameter $mu$.
      ],
      [
        Bias and Variance are identical, and so is the overall MSE in
        both analyses, since $overline(Y)$ is being compared to the same
        kind of target ($mu$) in both cases.
      ],
      [
        Only the Variance term is identical across the two analyses
        ($sigma^2/n$ in both cases); the Bias differs, because as a
        predictor $overline(Y)$ is biased (due to the irreducible
        error), while as an estimator it is exactly unbiased.
      ],
    ),
    correct: 1,
    note: [
      $overline(Y)$ is literally the same number, computed the same way,
      in both analyses --- so its Bias and Variance (as derived in
      Lecture 7 for the sample mean specifically) are identical
      regardless of which question you're using it to answer:
      $"Bias" = 0$ and $"Variance" = sigma^2 \/ n$. What differs is only
      the *target* being compared against:
      - As a *prediction* of a new outcome $Y$ (Lecture 7): $Y$ itself is
        random even once you know $mu$ exactly, contributing an
        irreducible error term $sigma^2$. Average MSE
        $= sigma^2 + 0 + sigma^2\/n$.
      - As an *estimator* of $mu$ (Lecture 8): $mu$ is a fixed parameter
        under the frequentist view, so there's no analogous leftover
        randomness to contribute an irreducible term. MSE
        $= 0 + sigma^2\/n$.
    ],
    explanations: (
      [
        False --- $overline(Y)$ doesn't change formula between the two
        uses; it's the exact same statistic playing two different roles.
      ],
      [Correct, matching the reasoning above.],
      [
        Ignores the irreducible error term entirely; the two MSEs differ
        by exactly $sigma^2$ (see Question 5's reasoning for why that
        term appears in one case and not the other).
      ],
      [
        Garbles which term is "the same" (it's Variance *and* Bias that
        match, not just Variance) and misattributes irreducible error to
        Bias --- irreducible error is a separate, third term in the
        decomposition, not a form of bias.
      ],
    ),
  ),
)
