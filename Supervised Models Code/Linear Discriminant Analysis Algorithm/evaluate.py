from sklearn.metrics import accuracy_score,precision_score,recall_score,f1_score

def evaluate_predictions(y_true,y_preds):

    accuracy = accuracy_score(y_true,y_preds)
    precision = precision_score(y_true,y_preds,average='micro')
    recall = recall_score(y_true,y_preds,average='micro')
    f1 = f1_score(y_true,y_preds,average='micro')
    metric_dict = {
		'accuracy': round(accuracy,2),
		'precision': round(precision,2),
		'recall' : round(precision,2),
		'f1': round(precision,2)
	}
    print(f'Accuracy: {accuracy * 100:.2f}%')
    print(f'Precision: {precision:.2f}')
    print(f'Recall: {recall:.2f}')
    print(f'F1 Score: {f1:.2f}')
    return metric_dict