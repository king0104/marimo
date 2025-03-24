package com.ssafy.marimo.common.converter;


import com.ssafy.marimo.common.annotation.DecryptedId;
import com.ssafy.marimo.common.util.IdEncryptionUtil;
import java.util.Set;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.core.convert.TypeDescriptor;
import org.springframework.core.convert.converter.ConditionalGenericConverter;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DecryptedIdConverter implements ConditionalGenericConverter {

    private final IdEncryptionUtil idEncryptionUtil;

    @Override
    public boolean matches(@NonNull final TypeDescriptor sourceType, final TypeDescriptor targetType) {
        return targetType.hasAnnotation(DecryptedId.class);
    }

    @Override
    public Set<ConvertiblePair> getConvertibleTypes() {
        return Set.of(
                new ConvertiblePair(String.class, Integer.class)
        );
    }

    @Override
    public Object convert(Object source, TypeDescriptor sourceType, TypeDescriptor targetType) {
        return idEncryptionUtil.decrypt((String) source);
    }
}
