# Feedback System Guide - Meningkatkan Model Accuracy

**Date:** December 21, 2025

---

## Overview

Arbtilant sudah memiliki **feedback system** yang membantu meningkatkan model accuracy. Setiap kali user melaporkan hasil yang salah, data tersebut disimpan dan bisa digunakan untuk retrain model.

---

## How It Works

### User Flow

```
1. User scans plant
   ↓
2. Gets result (e.g., "100% Sehat")
   ↓
3. Result is WRONG
   ↓
4. Click "Report Incorrect Result"
   ↓
5. Feedback dialog appears
   ↓
6. User selects correct disease
   ↓
7. User adds comment (optional)
   ↓
8. Feedback saved to database
   ↓
9. Data used to improve model
```

### What Gets Captured

```
Feedback Data:
├── Scan ID (unique identifier)
├── Original prediction (e.g., "Sehat")
├── Confidence score (e.g., 0.95)
├── Correct disease (user selected)
├── User comment (optional)
├── Confidence rating (1-5 stars)
├── Timestamp
└── Device info
```

---

## Using Feedback System

### Step 1: Scan Plant

```
1. Open app
2. Go to Scan page
3. Take photo of plant
4. Wait for result
```

### Step 2: Check Result

```
Dialog shows:
- Photo of leaf
- "DETECTED: [Disease Name]"
- Confidence score
- Other possibilities
- Quick tips
```

### Step 3: Report If Wrong

```
If result is WRONG:
1. Click "Report Incorrect Result" link
2. Feedback dialog appears
```

### Step 4: Select Correct Disease

```
Feedback Dialog:
├── "Is this result correct?" → Select NO
├── "What's the correct disease?" → Select from list
├── "Any additional comments?" → Type feedback
└── "How confident are you?" → Rate 1-5 stars
```

### Step 5: Submit

```
Click "Submit Feedback"
↓
Data saved to database
↓
Confirmation message
```

---

## Feedback Dialog Details

### Location

`lib/Widgets/feedback_dialog.dart`

### Fields

1. **Is Correct?**

   - Yes: Confirms model is right
   - No: Indicates model is wrong

2. **Correct Disease**

   - Dropdown list of all diseases
   - User selects actual disease
   - Required if "No" selected

3. **Comments**

   - Optional text field
   - User can add notes
   - Examples:
     - "Photo was blurry"
     - "Disease was very mild"
     - "Different angle would help"

4. **Confidence Rating**
   - 1-5 stars
   - How confident is user about correction?
   - Helps weight feedback data

---

## Data Collection & Analysis

### Where Data Is Stored

**Option 1: Supabase (If Configured)**

```
Supabase Database
└── user_feedback table
    ├── id
    ├── scan_result_id
    ├── disease_id
    ├── is_correct
    ├── corrected_disease_id
    ├── feedback_text
    ├── confidence_rating
    └── created_at
```

**Option 2: Local Hive (If Offline)**

```
Hive Database
└── feedback box
    ├── feedback_1
    ├── feedback_2
    └── feedback_n
```

### Analyzing Feedback

**Questions to Answer:**

1. **Which diseases are most misclassified?**

   ```
   SELECT corrected_disease_id, COUNT(*) as count
   FROM user_feedback
   WHERE is_correct = false
   GROUP BY corrected_disease_id
   ORDER BY count DESC
   ```

2. **What's the accuracy per disease?**

   ```
   SELECT disease_id,
          COUNT(*) as total,
          SUM(CASE WHEN is_correct THEN 1 ELSE 0 END) as correct,
          (SUM(CASE WHEN is_correct THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) as accuracy
   FROM user_feedback
   GROUP BY disease_id
   ```

3. **Which images are problematic?**
   ```
   SELECT scan_result_id, feedback_text
   FROM user_feedback
   WHERE is_correct = false
   ORDER BY created_at DESC
   LIMIT 20
   ```

---

## Using Feedback for Model Improvement

### Step 1: Export Feedback Data

```python
# Connect to Supabase
import supabase

client = supabase.create_client(url, key)

# Get all feedback
feedback = client.table('user_feedback').select('*').execute()

# Convert to DataFrame
import pandas as pd
df = pd.DataFrame(feedback.data)
```

### Step 2: Identify Problem Cases

```python
# Find misclassified cases
wrong_predictions = df[df['is_correct'] == False]

# Group by disease
by_disease = wrong_predictions.groupby('corrected_disease_id').size()
print(by_disease.sort_values(ascending=False))

# Example output:
# hawar: 45 cases
# powdery_mildew: 12 cases
# rust: 8 cases
```

### Step 3: Collect Images

```python
# For each misclassified case, get the image
for idx, row in wrong_predictions.iterrows():
    scan_id = row['scan_result_id']
    correct_disease = row['corrected_disease_id']

    # Get image from storage
    image_path = f"scan_images/{scan_id}.jpg"

    # Move to training dataset
    destination = f"dataset/{correct_disease}/{scan_id}.jpg"
    shutil.copy(image_path, destination)
```

### Step 4: Retrain Model

```python
# Use collected images to retrain
# See MODEL_IMPROVEMENT_GUIDE.md for details
```

---

## Feedback Statistics

### Tracking Metrics

```
Total Feedback Collected: 150
├── Correct Predictions: 110 (73%)
└── Wrong Predictions: 40 (27%)

Wrong Predictions by Disease:
├── Hawar: 20 (50%)
├── Powdery Mildew: 12 (30%)
├── Rust: 5 (12%)
└── Other: 3 (8%)

User Confidence (1-5 stars):
├── 5 stars: 85 (57%)
├── 4 stars: 45 (30%)
├── 3 stars: 15 (10%)
├── 2 stars: 4 (3%)
└── 1 star: 1 (1%)
```

### Dashboard (Future)

Could create dashboard to show:

- Real-time feedback count
- Accuracy trends
- Problem diseases
- User confidence levels

---

## Best Practices

### For Users

1. **Be Specific**

   - Select exact disease, not "Other"
   - Add helpful comments
   - Rate confidence honestly

2. **Provide Context**

   - Mention if photo was blurry
   - Note disease severity
   - Mention plant type if relevant

3. **Report Consistently**
   - Report all wrong predictions
   - Don't skip feedback
   - Help improve model

### For Developers

1. **Monitor Feedback**

   - Check feedback regularly
   - Identify patterns
   - Prioritize improvements

2. **Communicate**

   - Thank users for feedback
   - Show improvements made
   - Build community

3. **Iterate**
   - Collect → Analyze → Improve → Deploy
   - Repeat cycle
   - Track improvements

---

## Example Scenarios

### Scenario 1: Hawar Misclassified

```
User Action:
1. Scans hawar leaf
2. Gets: "100% Sehat"
3. Clicks "Report Incorrect Result"
4. Selects "Hawar" as correct disease
5. Comments: "Leaf had clear hawar symptoms"
6. Rates confidence: 5 stars
7. Submits

Data Saved:
- scan_id: abc123
- original_prediction: "Sehat"
- corrected_disease: "Hawar"
- feedback_text: "Leaf had clear hawar symptoms"
- confidence_rating: 5
- timestamp: 2025-12-21 10:30:00

Usage:
- Image added to training dataset
- Used to retrain model
- Model learns hawar pattern better
```

### Scenario 2: Correct Prediction

```
User Action:
1. Scans healthy leaf
2. Gets: "95% Sehat"
3. Agrees with result
4. Clicks "Disease Info" to learn more
5. No feedback needed

Data Saved:
- scan_id: def456
- original_prediction: "Sehat"
- is_correct: true
- timestamp: 2025-12-21 10:35:00

Usage:
- Confirms model is working
- Increases confidence in model
- Validates training data
```

---

## Troubleshooting

### Feedback Not Saving

**Check:**

1. Is Supabase configured?
2. Is internet connection working?
3. Are permissions correct?

**Solution:**

- Feedback saved locally to Hive
- Will sync when online
- Check logs for errors

### Can't Find Disease in List

**Solution:**

1. Check disease name spelling
2. Use "Other" if not in list
3. Add comment with disease name

### Feedback Dialog Not Appearing

**Check:**

1. Is "Report Incorrect Result" link visible?
2. Is dialog widget imported?
3. Are there any errors in console?

---

## Future Enhancements

### Planned Features

1. **Feedback Analytics Dashboard**

   - Real-time feedback metrics
   - Accuracy trends
   - Problem identification

2. **Automated Model Retraining**

   - Trigger retraining when threshold reached
   - Automatic deployment
   - A/B testing

3. **User Gamification**

   - Reward users for feedback
   - Leaderboard
   - Badges

4. **Advanced Analysis**
   - Identify image quality issues
   - Detect systematic biases
   - Recommend improvements

---

## Summary

### Current Status

- ✅ Feedback system implemented
- ✅ Data collection working
- ✅ Storage configured
- ✅ Ready for use

### How to Use

1. Scan plant
2. If result wrong, click "Report Incorrect Result"
3. Select correct disease
4. Add comments (optional)
5. Submit feedback

### Impact

- Collects real-world data
- Identifies model weaknesses
- Enables model improvement
- Improves accuracy over time

### Next Steps

1. Use feedback system regularly
2. Collect feedback data
3. Analyze patterns
4. Retrain model with new data
5. Deploy improved model

---

**Status:** ✅ FEEDBACK SYSTEM READY

Start using it to help improve model accuracy!
