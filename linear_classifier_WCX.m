% Linear classifier, binary classifier
% Author: Weichen Xu
% Date: 12/13/2015
% linear_train: positive_set, negative_set
% linear_predict: predict_set, return lable
classdef linear_classifier_WCX
    properties
        W;
        alpha;
    end
    methods
        % set initial training attributes
        function obj = linear_classifier_WCX(w, a)
            obj.W = w;
            obj.alpha = a;
        end
        % linear training
        function obj = linear_training_WCX(obj_b, pos, neg)
            %% init trainging set & training labels
            % positive: 1, negative: -1
            w = obj_b.W;
            [~,pos_size] = size(pos);
            [~,neg_size] = size(neg);
            Lables = zeros(pos_size+neg_size,1);
            Lables(1:pos_size,:) = 1;
            Lables(pos_size+1:neg_size, :) = -1;
            Training_set = [pos neg];
            %% set training falg and start training
            train_finish = false;
            while ~train_finish
                train_finish = true;
                for i = 1:pos_size+neg_size
                    if Lables(i, 1)*w*Training_set<0
                        train_finish = false;
                        w = w+obj_b.alpha*Lables(i, 1)*w*Training_set;
                    end
                end
            end
            obj.W = w;
        end
        % linear predict
        % input: feature matrix, v*n by row size = vector size
        function predict_lables = linear_predict_WCX(obj, testing)
            predict_lables = testing.'*obj.W;
        end
    end
    
end

