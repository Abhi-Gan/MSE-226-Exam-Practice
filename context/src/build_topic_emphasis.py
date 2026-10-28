#!/usr/bin/env python3
"""
Builds context/cleaned/topic_emphasis.json from the minutes-per-topic
numbers that three LLM agents reported after tagging every timed segment
of every raw lecture transcript (see extract_timed_segments.py) against
the instructor's own midterm_review.md outline as the fixed taxonomy.

The number-crunching below (dict construction, ranking) is deterministic
and reproducible from this file. The *inputs* -- which segment belongs to
which topic, and therefore each topic's total minutes -- are not: they
came from an LLM reading ~22,000 lines of raw transcript and exercising
judgment about topic boundaries. If a number here looks wrong, the fix is
to re-examine the raw transcript for that lecture, not to tweak this
script.

Run: python3 build_topic_emphasis.py
Writes: ../cleaned/topic_emphasis.json
"""
import json
import os

# label -> {"lecture": "...", "lecture_minutes": {session: minutes}, "problem_session_minutes": {session: minutes}}
# Minutes are as reported by the tagging agents (see conversation record / PR description).
TOPICS = [
    # Lecture 1
    dict(id="l1_three_forms_of_generalization", label="Three forms of generalization: prediction, inference, causality.",
         lecture="Lecture 1: Introduction to Data Science",
         lecture_minutes={"2026_09_22": 2.6, "2026_10_22": 5.7}),
    dict(id="l1_population_vs_sample", label="Population vs. sample.",
         lecture="Lecture 1: Introduction to Data Science",
         lecture_minutes={"2026_09_22": 12.6},
         problem_session_minutes={"2026_10_23_Problem_Session": 1.0}),
    dict(id="l1_sample_random_sampling", label="Sample generated via independent random sampling from the population.",
         lecture="Lecture 1: Introduction to Data Science",
         lecture_minutes={"2026_09_22": 4.0}),
    dict(id="l1_outcomes_covariates", label="Outcomes (Y) and covariates/features (X).",
         lecture="Lecture 1: Introduction to Data Science",
         lecture_minutes={"2026_09_22": 5.6}),
    dict(id="l1_prediction_not_causation", label="Prediction involves correlation or association; correlation/association is not causation.",
         lecture="Lecture 1: Introduction to Data Science",
         lecture_minutes={"2026_09_22": 6.4}),
    dict(id="exam_logistics", label="Exam logistics (content-relevant parts only)",
         lecture="(meta)",
         lecture_minutes={"2026_09_22": 0.6}),

    # Lecture 2
    dict(id="l2_supervised_learning_framework", label="Supervised learning framework.",
         lecture="Lecture 2: Introduction to Prediction", lecture_minutes={"2026_09_24": 5.9}),
    dict(id="l2_regression_vs_classification", label="Regression vs. classification.",
         lecture="Lecture 2: Introduction to Prediction", lecture_minutes={"2026_09_24": 1.0}),
    dict(id="l2_prediction_error_measures", label="Prediction error measures (e.g., squared error, absolute deviation).",
         lecture="Lecture 2: Introduction to Prediction", lecture_minutes={"2026_09_24": 6.0}),
    dict(id="l2_initial_ideas_means", label="Initial ideas: sample means, group means.",
         lecture="Lecture 2: Introduction to Prediction", lecture_minutes={"2026_09_24": 11.1}),
    dict(id="l2_ols_definition", label="OLS linear regression: Definition.",
         lecture="Lecture 2: Introduction to Prediction", lecture_minutes={"2026_09_24": 12.0},
         problem_session_minutes={"2026_10_23_Problem_Session": 5.1},
         tested_2025_midterm=["Q7 (mean/median as optimizers, shared w/ PS1)"]),
    dict(id="l2_ols_coefficient_interpretation", label="OLS linear regression: Coefficient interpretation (categorical features, continuous features).",
         lecture="Lecture 2: Introduction to Prediction", lecture_minutes={"2026_09_24": 8.0},
         tested_2025_midterm=["Q1"]),
    dict(id="l2_ols_collinearity", label="OLS linear regression: Collinearity issues.",
         lecture="Lecture 2: Introduction to Prediction", lecture_minutes={"2026_09_24": 6.9}),
    dict(id="l2_feature_eng_centering", label="Feature engineering: Centering and standardization.",
         lecture="Lecture 2: Introduction to Prediction", lecture_minutes={"2026_09_24": 2.1}),
    dict(id="l2_feature_eng_higher_order", label="Feature engineering: Higher-order terms, interaction terms.",
         lecture="Lecture 2: Introduction to Prediction", lecture_minutes={"2026_09_24": 5.4, "2026_10_01": 2.0}),
    dict(id="l2_feature_eng_log", label="Feature engineering: Log transformations.",
         lecture="Lecture 2: Introduction to Prediction", lecture_minutes={"2026_09_24": 1.6, "2026_10_01": 0.8}),
    dict(id="l2_r2_definition_limitations", label="R^2: definition and limitations.",
         lecture="Lecture 2: Introduction to Prediction", lecture_minutes={"2026_09_24": 6.0, "2026_09_29": 3.6},
         problem_session_minutes={"2026_10_23_Problem_Session": 2.9},
         tested_2025_midterm=["Q11"], tested_2025_final_in_scope=["Q5 (R^2/overfitting)"]),
    dict(id="l2_in_sample_vs_out_of_sample", label="In-sample vs. out-of-sample error.",
         lecture="Lecture 2: Introduction to Prediction (recurring through L3-L4)",
         lecture_minutes={"2026_09_24": 10.0, "2026_09_29": 8.0, "2026_10_01": 6.4},
         notes="Biggest single aggregation judgment call from the tagging agent: this bucket absorbed the R^2-critique, the formal generalization-error definition, and the feature-selection-contamination discussion across three lectures since none have a more specific bullet of their own."),

    # Lecture 3
    dict(id="l3_tvt_framework", label="Train-validate-test framework:",
         lecture="Lecture 3: Train-Validate-Test and Regularization", lecture_minutes={"2026_09_29": 7.7}),
    dict(id="l3_tvt_validation", label="Train-validate-test framework: Validation: select best model.",
         lecture="Lecture 3: Train-Validate-Test and Regularization", lecture_minutes={"2026_09_29": 3.9}),
    dict(id="l3_tvt_test", label="Train-validate-test framework: Test: unbiased error estimate.",
         lecture="Lecture 3: Train-Validate-Test and Regularization", lecture_minutes={"2026_09_29": 6.5},
         tested_2025_final_in_scope=["(validation-set bias discussed broadly under this bullet)"]),
    dict(id="l3_regularization_parent", label="Regularization (penalized SSE objectives):",
         lecture="Lecture 3: Train-Validate-Test and Regularization", lecture_minutes={"2026_09_29": 3.2}),
    dict(id="l3_ridge", label="Regularization (penalized SSE objectives): Ridge",
         lecture="Lecture 3: Train-Validate-Test and Regularization", lecture_minutes={"2026_09_29": 2.8},
         tested_2025_midterm=["Q3"]),
    dict(id="l3_lasso", label="Regularization (penalized SSE objectives): Lasso",
         lecture="Lecture 3: Train-Validate-Test and Regularization", lecture_minutes={"2026_09_29": 1.2},
         tested_2025_midterm=["Q2"]),
    dict(id="l3_comparing_ols_ridge_lasso", label="Comparing OLS vs. ridge vs. lasso.",
         lecture="Lecture 3: Train-Validate-Test and Regularization", lecture_minutes={"2026_09_29": 9.1},
         problem_session_minutes={"2026_10_23_Problem_Session": 2.7},
         tested_2025_final_in_scope=["Q6 (ridge vs lasso)"]),
    dict(id="l3_learning_algo_vs_fitted_model", label="Learning algorithms vs. fitted models.",
         lecture="Lecture 3: Train-Validate-Test and Regularization", lecture_minutes={"2026_09_29": 5.1, "2026_10_01": 4.0, "2026_10_08": 4.0}),

    # Lecture 4
    dict(id="l4_kfold_definition", label="K-fold cross-validation: definition.",
         lecture="Lecture 4: Cross-Validation", lecture_minutes={"2026_10_01": 6.2}),
    dict(id="l4_cv_error_estimate", label="CV error estimate.",
         lecture="Lecture 4: Cross-Validation", lecture_minutes={"2026_10_01": 3.4}),
    dict(id="l4_which_model_cv_corresponds_to", label="Which model does the CV error estimate correspond to?",
         lecture="Lecture 4: Cross-Validation", lecture_minutes={"2026_10_01": 5.8}),
    dict(id="l4_choice_of_k", label="Choice of K (impacts and tradeoffs).",
         lecture="Lecture 4: Cross-Validation", lecture_minutes={"2026_10_01": 16.1},
         tested_2025_midterm=["Q12 (precision/cost tradeoff vs. train-test split)"]),
    dict(id="l4_traintest_vs_cv", label="Train-test split vs. CV.",
         lecture="Lecture 4: Cross-Validation", lecture_minutes={"2026_10_01": 10.9},
         problem_session_minutes={"2026_10_16_Problem_Session": 4.6, "2026_10_23_Problem_Session": 1.9},
         tested_2025_midterm=["Q12"]),

    # Lecture 5
    dict(id="l5_binary_classification", label="Binary classification (Y in {0,1}).",
         lecture="Lecture 5: Classification", lecture_minutes={"2026_10_06": 12.9}),
    dict(id="l5_simple_error_metrics", label="Simple error metrics: 0-1 loss, accuracy.",
         lecture="Lecture 5: Classification", lecture_minutes={"2026_10_06": 8.3}),
    dict(id="l5_tvt_cv_for_classification", label="Train-validate-test, CV for classification.",
         lecture="Lecture 5: Classification", lecture_minutes={"2026_10_06": 0.6}),
    dict(id="l5_confusion_matrix", label="Confusion matrix (true/false positives/negatives; the tradeoff between false positives and false negatives; includes class-imbalance discussion, which has no separate taxonomy bullet).",
         lecture="Lecture 5: Classification", lecture_minutes={"2026_10_06": 23.9, "2026_10_08": 8.0},
         problem_session_minutes={"2026_10_23_Problem_Session": 1.6},
         tested_2025_midterm=["Q13"]),
    dict(id="l5_knn_example", label="Example: k-nearest neighbors classification.",
         lecture="Lecture 5: Classification", lecture_minutes={"2026_10_06": 11.2}),
    dict(id="l5_roc_auc", label="ROC curves and AUC.",
         lecture="Lecture 5: Classification", lecture_minutes={"2026_10_06": 8.0, "2026_10_08": 4.0},
         problem_session_minutes={"2026_10_23_Problem_Session": 0.7},
         tested_2025_midterm=["Q15 -- instructor's own pick for 'favorite example question hitting a lecture's core takeaway' (per 2026_10_23 problem session)"]),

    # Lecture 6
    dict(id="l6_general_framing", label="Lecture 6: Optimization View of Learning (general framing)",
         lecture="Lecture 6: Optimization View of Learning", lecture_minutes={"2026_10_08": 2.8}),
    dict(id="l6_mle_general", label="Maximum likelihood estimators (OLS, logistic regression). Three-step approach to MLE.",
         lecture="Lecture 6: Optimization View of Learning", lecture_minutes={"2026_10_08": 12.7},
         problem_session_minutes={"2026_10_23_Problem_Session": 8.3},
         tested_2025_midterm=["Q9", "Q10"]),
    dict(id="l6_ols_as_mle", label="OLS as MLE (Gaussian noise assumption; MLE for beta and sigma^2).",
         lecture="Lecture 6: Optimization View of Learning", lecture_minutes={"2026_10_08": 15.9}),
    dict(id="l6_logistic_as_mle", label="Logistic regression as MLE (logistic curve, 'divide by 4' rule, threshold tuning, regularization).",
         lecture="Lecture 6: Optimization View of Learning", lecture_minutes={"2026_10_08": 9.0, "2026_10_13": 9.0},
         tested_2025_midterm=["Q13", "Q14"]),
    dict(id="l6_threshold_tuning", label="Logistic regression as MLE: Threshold tuning.",
         lecture="Lecture 6: Optimization View of Learning",
         problem_session_minutes={"2026_10_23_Problem_Session": 0.5},
         tested_2025_midterm=["Q13"]),
    dict(id="l6_neural_networks", label="Neural networks (logistic regression as a one-layer neural network; multi-layer networks; fitting via non-convex optimization). In scope -- see correction note.",
         lecture="Lecture 6: Optimization View of Learning",
         lecture_minutes={"2026_10_08": 6.0, "2026_10_13": 6.0, "Lecture_6_Supplemental_video": 6.6},
         tested_2025_midterm=["Q14"], tested_2025_final_in_scope=["Q1 (CV mechanics; model being a tree/NN is incidental)"]),
    dict(id="l6_decision_trees", label="Decision trees (greedy splitting algorithm; ensemble methods: random forests, gradient boosting). In scope -- see correction note.",
         lecture="Lecture 6: Optimization View of Learning",
         lecture_minutes={"2026_10_13": 4.9, "Lecture_6_Supplemental_video": 4.9},
         tested_2025_final_in_scope=["Q1"]),
    dict(id="l6_tradeoffs_across_methods", label="Tradeoffs across methods (computation, sample size, interpretation).",
         lecture="Lecture 6: Optimization View of Learning", lecture_minutes={"2026_10_13": 8.1}),

    # Lecture 7
    dict(id="l7_evaluation_of_learning_algorithms", label="Evaluation of learning algorithms.",
         lecture="Lecture 7: Bias-Variance Decomposition", lecture_minutes={"2026_10_13": 10.7, "2026_10_20": 6.8}),
    dict(id="l7_frequentist_sampling_distributions", label="Frequentist approach and sampling distributions ('parallel universe' thought experiment; redraw training data each universe; average MSE across universes).",
         lecture="Lecture 7: Bias-Variance Decomposition", lecture_minutes={"2026_10_13": 20.0, "2026_10_15": 27.3},
         problem_session_minutes={"2026_10_16_Problem_Session": 14.6}),
    dict(id="l7_bias_variance_decomposition", label="Bias-variance decomposition for prediction: Average MSE = irreducible error + Bias^2 + Variance.",
         lecture="Lecture 7: Bias-Variance Decomposition",
         lecture_minutes={"2026_10_13": 20.0, "2026_10_15": 28.3, "2026_10_20": 10.0, "2026_10_22": 7.2},
         problem_session_minutes={"2026_10_16_Problem_Session": 14.8, "2026_10_23_Problem_Session": 1.4},
         tested_2025_midterm=["Q4 (bias)", "Q5 (variance)"],
         tested_2025_final_in_scope=["Q2", "Q3"],
         notes="Highest-emphasis topic in the entire course by combined minutes."),
    dict(id="l7_gauss_markov", label="Gauss-Markov Theorem for OLS (assumptions A1-A3; effect of adding/removing features; implications for ridge/lasso).",
         lecture="Lecture 7: Bias-Variance Decomposition", lecture_minutes={"2026_10_20": 31.3},
         problem_session_minutes={"2026_10_23_Problem_Session": 0.5},
         notes="Lives in lecture7_bias_variance_decomp.pdf's appendix, not lecture8_frequentist.pdf, despite the name."),
    dict(id="l7_decomposition_not_tradeoff", label="Bias-variance decomposition framed as a decomposition, not strictly a 'tradeoff.'",
         lecture="Lecture 7: Bias-Variance Decomposition", lecture_minutes={"2026_10_15": 5.0, "2026_10_20": 13.7},
         problem_session_minutes={"2026_10_23_Problem_Session": 1.2}),
    dict(id="l7_irreducible_error", label="'Irreducible' error (as a named, re-emphasized concept).",
         lecture="Lecture 7: Bias-Variance Decomposition", lecture_minutes={"2026_10_13": 9.0, "2026_10_15": 9.1, "2026_10_20": 3.4},
         tested_2025_final_in_scope=["Q9"]),
    dict(id="l7_double_descent", label="Double descent.",
         lecture="Lecture 7: Bias-Variance Decomposition", lecture_minutes={"2026_10_20": 10.5}),

    # Lecture 8
    dict(id="l8_estimation_uncertainty_quantification", label="Estimation and uncertainty quantification.",
         lecture="Lecture 8: Introduction to Frequentist Inference", lecture_minutes={"2026_10_22": 7.4}),
    dict(id="l8_parametric_inference", label="Parametric inference.",
         lecture="Lecture 8: Introduction to Frequentist Inference", lecture_minutes={"2026_10_22": 2.5}),
    dict(id="l8_parametric_estimation_framework", label="Parametric estimation framework (unknown population parameter theta; estimator theta-hat from the sample; sampling distribution of theta-hat).",
         lecture="Lecture 8: Introduction to Frequentist Inference", lecture_minutes={"2026_10_22": 10.5}),
    dict(id="l8_sampling_distribution_of_estimator", label="Sampling distribution of theta-hat.",
         lecture="Lecture 8: Introduction to Frequentist Inference", lecture_minutes={"2026_10_22": 7.6},
         tested_2025_midterm=["Q6 (CLT/sampling distribution of Ybar)"]),
    dict(id="l8_bias_variance_se_mse_of_estimator", label="Bias, variance, standard error, average MSE (of the estimator) -- no irreducible-error term, unlike the Lecture 7 prediction decomposition.",
         lecture="Lecture 8: Introduction to Frequentist Inference", lecture_minutes={"2026_10_22": 15.4},
         problem_session_minutes={"2026_10_23_Problem_Session": 0.7}),

    # Lecture 9 (in-scope portion only)
    dict(id="l9_clt", label="Central Limit Theorem (CLT): Ybar ~ N(mu, sigma^2/n) for large n.",
         lecture="Lecture 9: Standard Errors and Confidence Intervals (in-scope portion)",
         lecture_minutes={"2026_10_22": 16.0, "2026_10_27": 14.4},
         tested_2025_midterm=["Q6"]),
    dict(id="l9_se_ci_sample_mean", label="SE and confidence interval for the sample mean: SE-hat = sigma-hat/sqrt(n); 95% CI = Ybar +/- 1.96*SE-hat.",
         lecture="Lecture 9: Standard Errors and Confidence Intervals (in-scope portion)",
         lecture_minutes={"2026_10_22": 1.4, "2026_10_27": 16.0},
         problem_session_minutes={"2026_10_23_Problem_Session": 1.7},
         tested_2025_midterm=["Q8 (SE scaling: n=100 vs n=10,000)"]),
    dict(id="l9_interpreting_cis", label="Interpreting confidence intervals: the true parameter is in the CI in 95% of 'parallel universes' (repeated-sampling realizations).",
         lecture="Lecture 9: Standard Errors and Confidence Intervals (in-scope portion)",
         lecture_minutes={"2026_10_27": 22.8}),

    # Problem-set review pointers (from the 2026_10_23 midterm review session only)
    dict(id="ps1_review_pointers", label="Problem Set 1 -- review pointers (mean/median as optimizers; OLS residuals sum to zero; OLS line passes through (Xbar, Ybar)).",
         lecture="(PS review)", problem_session_minutes={"2026_10_23_Problem_Session": 2.2}),
    dict(id="ps2_review_pointers", label="Problem Set 2 -- review pointers (centering/standardization preserves R^2; coefficient interpretation; collinearity hurts interpretation not prediction; train/val/test size effects).",
         lecture="(PS review)", problem_session_minutes={"2026_10_23_Problem_Session": 1.8}),
    dict(id="ps3_review_pointers", label="Problem Set 3 -- review pointers (WLS/heteroskedasticity; quantile regression; missing-data imputation; log loss/logistic regression; decision trees/Gini/random forests).",
         lecture="(PS review)", problem_session_minutes={"2026_10_23_Problem_Session": 12.8},
         notes="Most heavily re-emphasized problem set in the review session."),
]

# Practice questions the instructor/TAs actually walked through in the
# 2026_10_23 midterm review session -- direct calibration signal for new
# question difficulty/style, independent of the minutes tally above.
CALIBRATION_QUESTIONS = [
    dict(question="OLS coefficients on a 'stacked/duplicated dataset' (same rows repeated)",
         topic_id="l2_ols_definition",
         note="Tests objective-function reasoning: duplicating the data doubles the SSE objective but doesn't change the argmin."),
    dict(question="Ridge regression as lambda -> 0", topic_id="l3_ridge",
         note="Ridge reduces exactly to OLS."),
    dict(question="Ridge/Lasso behavior as lambda -> infinity", topic_id="l3_comparing_ols_ridge_lasso", note=None),
    dict(question="Bias from omitting one of two relevant features, using the exam's own 'Data Generating Process' notes",
         topic_id="l7_bias_variance_decomposition",
         note="Common mistake flagged by TAs: students who don't read the DGP/notes page get this wrong."),
    dict(question="Variance comparison between a model using {A,B} vs. {B,C,D} where C,D are uncorrelated with everything",
         topic_id="l7_bias_variance_decomposition",
         note="Flagged as trickier -- hinges on correctly reasoning about uncorrelated-feature variance."),
    dict(question="Standard error comparison for n=100 vs. n=10,000 sample-mean estimates",
         topic_id="l9_se_ci_sample_mean",
         note="Common mistake: SE drops by sqrt(multiple), not by the multiple itself."),
    dict(question="Define the likelihood for a sequence of coin flips", topic_id="l6_mle_general", note=None),
    dict(question="Multi-part MLE question", topic_id="l6_mle_general",
         note="TAs flagged a 'double jeopardy' dependency between sub-parts -- an error in an early part cascades."),
    dict(question="R^2 behavior under increasing polynomial-regression degree", topic_id="l2_r2_definition_limitations", note=None),
    dict(question="Comparing 10-fold CV vs. a single train-test split", topic_id="l4_traintest_vs_cv",
         note="Flagged by the instructor as inherently 'squishy' to write unambiguously."),
    dict(question="Classifying with a logistic-regression probability output and a decision threshold",
         topic_id="l6_threshold_tuning", note=None),
    dict(question="Logistic regression tied to log loss / MLE from the optimization lecture",
         topic_id="l6_mle_general", note=None),
    dict(question="ROC/AUC comparison across algorithms, combined with the false-positive/false-negative tradeoff",
         topic_id="l5_roc_auc",
         note="The instructor's own pick for the single best example question hitting a lecture's core takeaway."),
]

EXCLUDED_MINUTES = {
    "logistics_banter": {
        "2026_09_22": 42.9, "2026_09_24": 14.6, "2026_09_29": 29.6, "2026_10_01": 17.7,
        "2026_10_06": None, "2026_10_08": None, "2026_10_13": None, "2026_10_15": None,  # folded into the 45.3 batch total below
        "2026_10_20": None, "2026_10_22": None, "2026_10_27": None,  # folded into the 13.9 batch total below
        "2026_10_16_Problem_Session": 34.5, "2026_10_23_Problem_Session": 21.8,
    },
    "logistics_banter_batch_totals_where_not_split_by_file": {
        "2026_10_06+2026_10_08+2026_10_13+2026_10_15": 45.3,
        "2026_10_20+2026_10_22+2026_10_27": 13.9,
    },
    "out_of_midterm1_scope_m_estimation_robust_se": {"2026_10_27": 30.1},
}

SESSION_TOTAL_MINUTES = {
    "2026_09_22": 74.7, "2026_09_24": 83.2, "2026_09_29": 81.8, "2026_10_01": 79.1,
    "2026_10_06": 83.0, "2026_10_08": 82.2, "2026_10_13": 83.0, "2026_10_15": 83.0,
    "Lecture_6_Supplemental_video": 12.1,
    "2026_10_20": 81.6, "2026_10_22": 82.5, "2026_10_27": 82.1,
    "2026_10_16_Problem_Session": 68.5, "2026_10_23_Problem_Session": 68.6,
}


def combined_minutes(topic):
    lec = sum(topic.get("lecture_minutes", {}).values())
    ps = sum(topic.get("problem_session_minutes", {}).values())
    return round(lec, 1), round(ps, 1), round(lec + ps, 1)


def main():
    out_topics = []
    for t in TOPICS:
        lec_total, ps_total, combined = combined_minutes(t)
        out_topics.append({
            "id": t["id"],
            "label": t["label"],
            "lecture": t["lecture"],
            "lecture_minutes_by_session": t.get("lecture_minutes", {}),
            "lecture_minutes_total": lec_total,
            "problem_session_minutes_by_session": t.get("problem_session_minutes", {}),
            "problem_session_minutes_total": ps_total,
            "combined_minutes_total": combined,
            "tested_2025_midterm": t.get("tested_2025_midterm", []),
            "tested_2025_final_in_scope": t.get("tested_2025_final_in_scope", []),
            "notes": t.get("notes"),
        })

    ranking = sorted(out_topics, key=lambda x: x["combined_minutes_total"], reverse=True)
    top_20 = [{"id": t["id"], "label": t["label"], "combined_minutes_total": t["combined_minutes_total"]}
              for t in ranking[:20]]

    doc = {
        "purpose": (
            "Weighting signal for generating MS&E 226 Midterm 1 practice questions. "
            "The instructor has said in lecture that topics he spends more time on / "
            "repeats are proportionally more likely to be tested. This file quantifies "
            "that: approximate class-minutes spent per topic, derived from raw lecture "
            "transcript timestamps and tagged against the instructor's own "
            "midterm_review.md outline (the fixed taxonomy -- see each topic's `label`, "
            "copied verbatim from that deck)."
        ),
        "how_to_use": (
            "Prefer `combined_minutes_total` (lecture + problem-session time) as the "
            "primary weight; it is also precomputed and pre-sorted in `top_20_by_combined_minutes`. "
            "`problem_session_minutes` (from 2026_10_16 and 2026_10_23, the latter being "
            "the instructor's own midterm review session) is a distinct signal from "
            "`lecture_minutes`: time spent drilling/reviewing a topic reflects what's "
            "likely to be tested or commonly confusing, which may be an even stronger "
            "predictor than first-pass teaching time. `tested_2025_midterm` / "
            "`tested_2025_final_in_scope` cross-reference last year's exams (see "
            "context/cleaned/old_exams/) as a second, independent emphasis signal. "
            "`calibration_questions_from_midterm_review_session` lists the specific "
            "practice questions the instructor walked through in the 2026_10_23 review "
            "-- useful for calibrating new-question difficulty/style directly, not just topic weight."
        ),
        "methodology": (
            "1) context/src/extract_timed_segments.py split each raw transcript into "
            "~6-line segments tagged with [start-end timestamp, duration_seconds] "
            "(mechanical, deterministic). 2) An LLM agent walked every segment of every "
            "lecture/problem-session transcript (in 3 batches, matching the batches used "
            "for the main transcript cleanup) and assigned each to the single "
            "best-matching topic from midterm_review.md, excluding pure logistics/banter "
            "and (for 2026_10_27) content past the Midterm 1 scope boundary. Minutes per "
            "topic are summed segment durations. This tagging step is LLM judgment, not "
            "scripted -- see each batch's reported caveats below."
        ),
        "scope_correction": (
            "Neural networks and decision trees/ensembles (Lecture 6) ARE in scope for "
            "Midterm 1 -- midterm_review.pdf lists both with no [*] optional marker, and "
            "PS3 Problem 5 (trees) is an explicit review pointer. An earlier cleaning pass "
            "incorrectly flagged Lecture_6_Supplemental_video.md and final_2025.md "
            "Problem 1 as out-of-scope for this reason; both have been corrected in place."
        ),
        "caveats": [
            "Topic boundaries were judgment calls at natural shifts in the transcript, not a mechanical 1:1 segment-to-topic mapping -- treat minutes as approximate, not to the decimal place.",
            "'In-sample vs. out-of-sample error' (Lecture 2 bullet) absorbed a large recurring bucket across Lectures 2-4 since no more specific bullet existed for it -- the single biggest aggregation judgment call in this dataset.",
            "'Confusion matrix' absorbs the Lecture 6 class-imbalance discussion, since the taxonomy has no separate bullet for it.",
            "Minutes reflect ONE run through the material; they are a proxy for instructor emphasis, not a guarantee of exam weight -- combine with the tested_2025_* cross-reference and ordinary judgment, don't treat as the sole input.",
        ],
        "session_total_minutes": SESSION_TOTAL_MINUTES,
        "excluded_minutes": EXCLUDED_MINUTES,
        "top_20_by_combined_minutes": top_20,
        "topics": out_topics,
        "calibration_questions_from_midterm_review_session": CALIBRATION_QUESTIONS,
    }

    out_path = os.path.join(os.path.dirname(__file__), "..", "cleaned", "topic_emphasis.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=2)
    print(f"Wrote {out_path} ({len(out_topics)} topics, {len(CALIBRATION_QUESTIONS)} calibration questions)")


if __name__ == "__main__":
    main()
